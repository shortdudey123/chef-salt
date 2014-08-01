
# The address of the interface to bind to
default['salt']['master']['interface'] = '0.0.0.0'

default['salt']['master']['config_template'] = 'master.erb'
default['salt']['master']['config_cookbook'] = 'salt'

default['salt']['master']['package'] = 'salt-master'