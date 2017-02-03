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

default['salt']['master']['api']['user'] = {
  'enable' => false,
  'name' => 'saltapi',
  'password' => '$1$NVTrHnvI$SM9u1HFbwDei0ku5TJUM21',
  'manage_home' => false,
  'system' => true,
  'shell' => '/sbin/nologin',
  'comment' => 'Default Salt API User',
}

default['salt']['master']['config'] = {}

default['salt']['master']['api']['enable'] = false
default['salt']['master']['api']['install_opts'] = nil
default['salt']['master']['api']['package'] = 'salt-api'

default['salt']['master']['api']['config'] = {
  'disable_ssl' => true,
  'port' => 8000,
}
