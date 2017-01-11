# The master or masters to connect to. Only set if you wish to override the
# default searching behavior.
default['salt']['minion']['master'] = nil

# The environment in which to search for a master
# Setting this value to nil will search all environments
default['salt']['minion']['environment'] = node.chef_environment

default['salt']['minion']['config_template'] = 'minion.erb'
default['salt']['minion']['config_cookbook'] = 'salt'

default['salt']['minion']['package'] = case node['platform_family']
                                       when 'arch'
                                         'salt'
                                       when 'freebsd'
                                         'py27-salt'
                                       when 'gentoo'
                                         'app-admin/salt'
                                       else
                                         'salt-minion'
                                       end

default['salt']['minion']['config'] = {
  'id' => node.name,
  'grains' => {},
}
