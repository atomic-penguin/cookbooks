actions :create, :delete

# Path to export, should be unique.
# TODO - man exports says you can have one for each NFS type.
attribute :path, :kind_of => String, :name_attribute => true

# Clients are basically an array of hashes, don't see a way to validate that.
#[
#  {
#    'client' => '10.0.0.1',
#    'rw' => true,
#    'anongid' => 2
#  },
#  {
#    'client' => '*',
#    'ro' => true,
#    'root_squash' => true
#  }
#]
       
attribute :clients, :kind_of =>  Array

# TODO - Multiple clients can be defined...

# Don't see how to verify these attributes if they are multivalued.  Only a few
# of them can be defined for 'default options', the reset must relate to a 
# specific client string [eg clientip(opts)], so maybe just keep the defaults

# 
attribute :client, :kind_of => String

# <none> / sec=colon:delimeted:list
attribute :sec, :kind_of => Array, :default => []

# secure (default) / insecure
attribute :rw, :kind_of => Bool, :default => nil

# ro (default) / rw
attribute :rw, :kind_of => Bool, :default => nil

# sync (default) / async
attribute :async, :kind_of => Bool, :default => nil

# wdelay (default) / no_wdelay
attribute :no_wdelay, :kind_of => Bool, :default => nil

# hide (default) / nohide
attribute :nohide, :kind_of => Bool, :default => nil

# <none> (default) / crossmnt
attribute :crossmnt, :kind_of => Bool, :default => nil

# <none> (default) / subtree_check
attribute :subtree_check, :kind_of => Bool, :default => nil

# <none> (default) / insecure_locks
attribute :insecure_locks, :kind_of => Bool, :default => nil

# <none> (default) / no_acl
attribute :no_acl, :kind_of => Bool, :default => nil

# <none> / mountpoint | mountpoint=path
attribute :mountpoint, :default => nil

# <none> / fsid=num|root|uuid
attribute :fsid, :default => nil

# <none> / refer=path@host[+host][:path@host[+host]]
attribute :refer, :kind_of => String, :default => nil

# <none> / replicas=path@host[+host][:path@host[+host]]
attribute :replicas, :kind_of => String, :default => nil


# root_squash, no_root_squash, all_squash
attribute :user_id_mapping, :kind_of => String, :default => nil
attribute :anonuid, :kind_of => String
attribute :anongid, :kind_of => String
