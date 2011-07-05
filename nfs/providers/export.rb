#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: php
# Provider:: pear_package
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

require 'shellwords'

def action blah
  
end

action :create do
  unless exists?
    # TODO
  end
end

action :delete do
  if exists?
    # TODO
  end
end

def load_current_resource
  @current_resource = Chef::Resource::NfsExport.new(@new_resource.name)
  @current_resource.path(@new_resource.path)
  Chef::Log.debug("Checking for NFS export #{@current_resource.path}")

  # Check to see if there is a entry in /etc/fstab. Last entry for a volume wins.
  enabled = false
  ::File.foreach("/etc/exports") do |line|
    case line
    when /^[#\s]/
      next
    when [0, @new_resource.path.length] == @new_resource.path 
      # TODO
    end
  end
  @current_resource.enabled(enabled)
end

#private

def enable_export
  if export_options_unchanged?
    Chef::Log.debug("#{@new_resource} is already enabled - nothing to do")
    return nil
  else
    # The current options don't match what we have, so
    # disable, then enable.
    disable_export
  end
  ::File.open("/etc/exports", "a") do |fstab|
    fstab.puts(render_export(@new_resource))
    Chef::Log.debug("#{@new_resource} is enabled at #{@new_resource.path}")
  end
end

def disable_export
  match = parse_export(render_export(@current_resource))
  contents = []

  found = false
  ::File.readlines("/etc/exports").reverse_each do |line|
    if !found && parse_export(line) == match
      found = true
      Chef::Log.debug("#{@current_resource} is removed from fstab")
      next
    else
      contents << line
    end
  end

  ::File.open("/etc/exports", "w") do |fstab|
    contents.reverse_each { |line| fstab.puts line}
  end
end

def exists?
  # TODO
end

def parse_export line
  # /path/to/export  -opt,opt client client(opt,opt) client(opt)
  export = Hash.new
  args = Shellwords.shellwords(line)
  export[:path] = args.shift
  export[:clients] = Array.new
  args.each do |arg|
    case arg
    when /^[-\s]/
      arg.slice!(0)
      unless export.has_key?(:def_options)
        export[:def_options] = parse_options(arg)
      else
        raise "Duplicate default options for NFS export #{export[:path]}"
      end
    else
      export[:clients] << parse_client(arg)
    end
  end
  export
end

def parse_client client
  options = Hash.new
  # host(opta,optb=1,optc)
  options[:client], opts = *client.split(/\(([^)]+)\)/)
  unless opts.nil?
    options.merge!(parse_options opts)
  end
  options
end

def parse_options csv
  # ro,anonid=0,nosync
  options = Hash.new
  csv.split(',').each do |opt|
    opt = opt.split('=')
    options[opt.shift] = (opt.empty?) ? true : opt.shift
  end
  options
end

def render_export export
  line = export[:path] + ' '
  args = Array.new
  args << "-#{render_options(export[:def_options])}" unless export[:def_options].empty?
  export[:clients].each do |options|
    args << render_client(options)
  end
  
  line << args.join(' ')
  line
end

def render_client options
  host = options.delete(:client)
  host << "(#{render_options(options)})" unless options.empty?
  host
end

def render_options options
  values = Array.new
  options.each do |k, v|
    if v === true
      values << k
    else
      values << "#{k}=#{v}"
    end
  end
  values.join(',')
end
