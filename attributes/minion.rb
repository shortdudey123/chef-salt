
# Name of salt minion
default['salt']['minion']['id'] = node.name

# The master or masters to connect to. Only set if you wish to override the
# default searching behavior.
default['salt']['minion']['master'] = nil

# The environment in which to search for a master
# Setting this value to nil will search all environments
default['salt']['minion']['environment'] = node.chef_environment

default['salt']['minion']['config_template'] = 'minion.erb'
default['salt']['minion']['config_cookbook'] = 'salt'

case node['platform_family']
when 'arch'
  default['salt']['minion']['package'] = 'salt'
when 'freebsd'
  default['salt']['minion']['package'] = 'py27-salt'
when 'gentoo'
  default['salt']['minion']['package'] = 'app-admin/salt'
else
  default['salt']['minion']['package'] = 'salt-minion'
end

default['salt']['minion']['grains'] = {}
