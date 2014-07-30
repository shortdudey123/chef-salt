
# Name of salt minion
default['salt']['minion']['id'] = node.name

# The master or masters to connect to. Only set if you wish to override the
# default searching behavior.
default['salt']['minion']['master'] = nil

# The environment in which to search for a master
# Setting this value to nil will search all environments
default['salt']['minion']['master_environment'] = node.chef_environment

default['salt']['minion']['config_template'] = 'minion.erb'
default['salt']['minion']['config_cookbook'] = 'salt'