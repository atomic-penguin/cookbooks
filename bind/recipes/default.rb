#
# Cookbook Name:: bind 
# Recipe:: default
#
# Copyright 2011, Gerald L. Hevener, Jr, M.S.
# Copyright 2011, Eric G. Wolfe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

r = gem_package "net-ldap" do
  version '0.2.2'
  action :nothing
end

r.run_action(:install)

# Read ACL objects from data bag.
# These will be passed to the named.options template
search(:bind, "role:#{node["bind"]["acl-role"]}") do |acl|
  node["bind"]["acls"] << acl
end

# Install required packages
node["bind"]["packages"].each do |bind_pkg|
  package bind_pkg
end

# Copy /etc/named files into place.
node["bind"]["etc_cookbook_files"].each do |etc_file|
  cookbook_file "#{node["bind"]["sysconfdir"]}/#{etc_file}" do
    owner "named"
    group "named"
    mode "0644"
  end
end

# Create /var/named directory
directory node["bind"]["vardir"] do
  owner "named"
  group "named"
  mode "0750"
end

# Create /var/named subdirectories
%w[ data master slaves ].each do |subdir|
  directory "#{node["bind"]["vardir"]}/#{subdir}" do
    owner "named"
    group "named"
    mode "0770"
    recursive true
  end
end

# Copy /var/named files in place
node["bind"]["var_files"].each do |var_file|
  cookbook_file "#{node["bind"]["vardir"]}/#{var_file}" do
    owner "named"
    group "named"
    mode "0644"
  end
end

# Create rndc key file, if it does not exist
execute "rndc-key" do
  command node["bind"]["rndc_cmd"]
  not_if do
    File.exists?("/etc/rndc.key")
  end
end

file "/etc/rndc.key" do
  owner "named"
  group "named"
  mode "0600"
  action :touch
end

template "#{node["bind"]["sysconfdir"]}/named.options" do
  owner "named"
  group "named"
  mode  "0644"
  variables(
    :bind_acls => node["bind"]["acls"]
  )
end

# This is optional code to slurp DNS zones from Active Directory
# integrated domain controllers.  If you have a proper IP address
# management solution, you could replace the code to query an API
# on your IPAM server.
#
# Any query should use the '<<' operator to push results on to the
# node["bind"]["zones"] array.
#
# You can just use an override["bind"]["zones"] in a role or environment
# instead.  Or even a mix of both override, and API query to populate zones.
unless ( node["bind"]["ad"]["server"].nil? and node["bind"]["ad"]["binddn"].nil? and node["bind"]["ad"]["bindpw"].nil? )
  require 'rubygems'
  Gem.clear_paths
  require 'net/ldap'

  ldap = Net::LDAP.new(
    :host => node["bind"]["ad"]["server"],
    :auth => {
      :method => :simple,
      :username => node["bind"]["ad"]["binddn"],
      :password => node["bind"]["ad"]["bindpw"]
    }
  )

  if ldap.bind
    ldap.search(
      :base => node["bind"]["ad"]["domainzones"],
      :filter => node["bind"]["ad"]["filter"]) do |dnszone|
      node["bind"]["zones"] << dnszone['name'][0]
    end
  else
    Chef::Log.error("LDAP Bind failed with #{node["bind"]["ad"]["server"]}")
    raise
  end
end

# Render our template with role zones, or returned results from IPAM API query.
template "/etc/named.conf" do
  owner "named"
  group "named"
  mode 0644
  variables(
    :zones => node["bind"]["zones"] 
  )
end

service "named" do
  action [ :enable, :start ]
end
