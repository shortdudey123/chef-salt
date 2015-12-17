# Name of salt minion
default['salt']['minion']['id'] = node.name # DEPRECATED

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

default['salt']['minion']['grains'] = {} # DEPRECATED

default['salt']['minion']['config'] = {
  'id' => node.name,
  'grains' => {},
  'ipv6' => false,
  'user' => 'root',
  'master_port' => 4506,
  'pidfile' => '/var/run/salt-minion.pid',
  'root_dir' => '/',
  'pki_dir' => '/etc/salt/pki/minion',
  'cachedir' => '/var/cache/salt/minion',
  'verify_env' => true,
  'auth_timeout' => 60,
  'loop_interval' => 60,
  'color' => true,
  'strip_colors' => false,
  'sock_dir' => '/var/run/salt/minion',
  'open_mode' => false,
  'permissive_pki_access' => false,
  'state_verbose' => true,
  'state_output' => 'full',
  'hash_type' => 'md5',
  'log_file' => '/var/log/salt/minion',
  'key_logfile' => '/var/log/salt/key',
  'log_level' => 'warning',
  'log_level_logfile' => 'warning',
  'log_datefmt' => "'%H:%M:%S'",
  'log_datefmt_logfile' => "'%Y-%m-%d %H:%M:%S'",
  'log_fmt_console' => "'[%(levelname)-8s] %(message)s'",
  'log_fmt_logfile' => "'%(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s'",
  'return' => 'mysql'
}
