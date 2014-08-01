
# The address of the interface to bind to
default['salt']['master']['interface'] = '0.0.0.0'

default['salt']['master']['config_template'] = 'master.erb'
default['salt']['master']['config_cookbook'] = 'salt'

case node['platform_family']
when 'arch'
  default['salt']['master']['package'] = 'salt'
when 'freebsd'
  default['salt']['master']['package'] = 'py27-salt'
when 'gentoo'
  default['salt']['master']['package'] = 'app-admin/salt'
else
  default['salt']['master']['package'] = 'salt-master'
end