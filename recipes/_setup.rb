#
# Cookbook Name:: chef-salt
# Recipe:: _setup
#
# Copyright (C) 2016, Grant Ridder
# Copyright (C) 2014, Daryl Robbins
#
#
#

include_recipe 'salt::default'

include_recipe 'ohai'

ohai 'salt' do
  action :nothing
end

ohai_plugin 'salt' do
  source_file 'salt_plugin.rb'
  notifies :reload, 'ohai[salt]', :immediately
end

include_recipe 'salt::repo' if node['salt']['setup']['configure_repo']
