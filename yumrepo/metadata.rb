maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Recipes install and configure several popular RHEL and CentOS 5.x repositories"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.4"

%w{ redhat centos }.each do |os|
  supports os, ">= 5"
end

attribute "repo",
  :display_name => "repo",
  :description => "Hash of repo attributes",
  :type => "hash"

attribute "repo/epel/url",
  :display_name => "EPEL URL",
  :description => "URL for the EPEL repository"

attribute "repo/epel/enabled",
  :display_name => "EPEL enable",
  :description => "Boolean flag for the EPEL repository",
  :default => "true"

attribute "repo/epel/key",
  :display_name => "EPEL key",
  :description => "EPEL GPG signing key",
  :default => "RPM-GPG-KEY-EPEL" 

attribute "repo/elff/url",
  :display_name => "ELFF URL",
  :description => "URL for the ELFF repository"

attribute "repo/elff/enabled",
  :display_name => "ELFF enable",
  :description => "Boolean flag for the ELFF repository",
  :default => "true"

attribute "repo/elff/key",
  :display_name => "ELFF key",
  :description => "ELFF GPG signing key",
  :default => "RPM-GPG-KEY-ELFF"

attribute "repo/dellcommunity/url",
  :display_name => "Dell Community repo URL",
  :description => "URL for the Dell Community repository"

attribute "repo/dellfirmware/url",
  :display_name => "Dell Firmware repo URL",
  :description => "URL for the Dell Firmware repository"

attribute "repo/dellomsa/indep/url",
  :display_name => "Dell OMSA indep repo URL",
  :description => "URL for the Dell OMSA hardware independent repository"

attribute "repo/dellomsa/specific/url",
  :display_name => "Dell OMSA specific repo URL",
  :description => "URL for the Dell OMSA hardware specific repository"

attribute "repo/dell/enabled",
  :display_name => "Dell repo boolean",
  :description => "Boolean for the Dell OMSA, Community, and Firmware repositories. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/dell/key",
  :display_name => "Dell Key",
  :description => "Dell Community/OMSA GPG Signing Key",
  :default => "RPM-GPG-KEY-dell"

attribute "repo/libsmbios/key",
  :display_name => "libsmbios Key",
  :description => "Dell libsmbios Signing Key",
  :default => "RPM-GPG-KEY-libsmbios"

attribute "repo/vmware/release",
  :display_name => "VMware ESX release version",
  :description => "Used in determining the VMware repo URL",
  :default => "4.1"

attribute "repo/vmware/url",
  :display_name => "VMware Tools Repository URL",
  :description => "The URL for the VMWare Tools yum repository.  You can override the whole url or just override[:repo][:vmware][:release]"

attribute "repo/vmware/key",
  :display_name => "VMware Key",
  :description => "VMware GPG Signing Key",
  :default => "VMWARE-PACKAGING-GPG-KEY"

attribute "repo/vmware/enabled",
  :display_name => "VMware repo boolean",
  :description => "The VMware repository boolean. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/vmware/install_optional",
  :display_name => "VMware optional components",
  :description => "Whether or not optional VMware components should be installed.",
  :default => "false"
