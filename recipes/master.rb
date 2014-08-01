
include_recipe "salt::_setup"

package node['salt']['master']['package'] do
  version node['salt']['version'] if node['salt']['version']
  action :install
end

service 'salt-master' do 
  action :enable
end

template "/etc/salt/master" do
  source node['salt']['master']['config_template'] || 'master.erb'
  cookbook node['salt']['master']['config_cookbook'] || 'salt'
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, 'service[salt-master]'
end

service 'salt-master' do 
  action :start
end