#
# Cookbook Name:: chef-salt
# Recipe:: _setup
#
# Copyright (C) 2015, Grant Ridder
# Copyright (C) 2014, Daryl Robbins
#
#
#

include_recipe 'salt::default'

include_recipe 'ohai'

ohai 'reload_salt' do
  plugin 'salt'
  action :nothing
end

cookbook_file "#{node['ohai']['plugin_path']}/salt.rb" do
  # rubocop:disable Style/SingleSpaceBeforeFirstArg
  source 'salt_plugin.rb'
  owner  'root'
  group  node['root_group'] || 'root'
  mode   '0755'
  # rubocop:enable Style/SingleSpaceBeforeFirstArg
  notifies :reload, 'ohai[reload_salt]', :immediately
end

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  case node['platform']
  when 'ubuntu'
    apt_repository 'saltstack-salt' do
      # rubocop:disable Style/SingleSpaceBeforeFirstArg
      uri          'http://ppa.launchpad.net/saltstack/salt/ubuntu'
      distribution node['lsb']['codename']
      components   ['main']
      keyserver    'keyserver.ubuntu.com'
      key          '0E27C0A6'
      # rubocop:enable Style/SingleSpaceBeforeFirstArg
    end
  when 'debian'
    apt_repository 'saltstack-salt' do
      # rubocop:disable Style/SingleSpaceBeforeFirstArg
      uri          'http://debian.saltstack.com/debian'
      distribution "#{node['lsb']['codename']}-saltstack"
      components   ['main']
      key          'http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key'
      # rubocop:enable Style/SingleSpaceBeforeFirstArg
    end
  end
when 'rhel'
  include_recipe 'yum-epel' if node['platform_version'].to_i >= 5
end
