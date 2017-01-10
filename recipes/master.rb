#
# Cookbook Name:: chef-salt
# Recipe:: master
#
# Copyright (C) 2016, Grant Ridder
# Copyright (C) 2014, Daryl Robbins
#
#
#

include_recipe 'salt::_setup'

package node['salt']['master']['package'] do
  version node['salt']['version'] if node['salt']['version']
  options node['salt']['master']['install_opts'] unless node['salt']['master']['install_opts'].nil?
  action :install
end

service 'salt-master' do
  action :enable
end

master_config = node['salt']['master']['config'].to_h
master_config['rest_cherrypy'] = node['salt']['master']['api']['config'].to_h if node['salt']['master']['api']['enable']

template '/etc/salt/master' do
  source node['salt']['master']['config_template'] || 'master.erb'
  cookbook node['salt']['master']['config_cookbook'] || 'salt'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    config: master_config
  )
  helpers SaltCookbookHelper
  notifies :restart, 'service[salt-master]', :delayed
  notifies :restart, 'service[salt-api]', :delayed if node['salt']['master']['api']['enable']
  notifies :run, 'execute[wait for salt-master]', :delayed
end

execute 'wait for salt-master' do
  command 'sleep 5'
  action :nothing
  notifies :reload, 'ohai[salt]', :immediate
end

if Chef::Config[:solo]
  log 'Salt key exchange not supported on Chef solo' do
    level :warn
  end
else
  minion_search = "role:#{node['salt']['role']['minion']}"
  if node['salt']['master']['environment']
    minion_search += " AND chef_environment:#{node['salt']['master']['environment']}"
  end

  minions = search(:node, minion_search)

  log "Synchronizing keys for #{minions.length} minions"

  # Add minion keys to master PKI
  minions.each do |minion|
    next unless minion['salt'] && minion['salt']['public_key']

    file "/etc/salt/pki/master/minions/#{minion['salt']['minion']['config']['id']}" do
      action :create
      owner 'root'
      group 'root'
      mode '0644'
      content minion['salt']['public_key']
    end
    file "/etc/salt/pki/master/minions_pre/#{minion['salt']['minion']['config']['id']}" do
      action :delete
    end
  end
end

if node['salt']['master']['api']['enable']
  package node['salt']['master']['api']['package'] do
    version node['salt']['version'] if node['salt']['version']
    options node['salt']['master']['api']['install_opts'] unless node['salt']['master']['api']['install_opts'].nil?
    action :install
  end

  service 'salt-api' do
    action :enable
  end
end

# Stub for chefspec since we test each recipe in isolation
ohai 'salt' do
  action :nothing
end if defined?(ChefSpec)
