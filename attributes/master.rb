default['salt']['master']['config_template'] = 'master.erb'
default['salt']['master']['config_cookbook'] = 'salt'

default['salt']['master']['environment']     = node.chef_environment

default['salt']['master']['package'] = case node['platform_family']
                                       when 'arch'
                                         'salt'
                                       when 'freebsd'
                                         'py27-salt'
                                       when 'gentoo'
                                         'app-admin/salt'
                                       else
                                         'salt-master'
                                       end

default['salt']['master']['config'] = {}

default['salt']['master']['api']['enable'] = false
default['salt']['master']['api']['install_opts'] = nil
default['salt']['master']['api']['package'] = 'salt-api'

default['salt']['master']['api']['config'] = {
  'disable_ssl' => true,
  'port' => 8000,
}
