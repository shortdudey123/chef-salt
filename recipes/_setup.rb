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

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  case node['platform']
  when 'ubuntu'
    apt_repository 'saltstack-salt' do
      uri          'http://ppa.launchpad.net/saltstack/salt/ubuntu'
      distribution node['lsb']['codename']
      components   ['main']
      keyserver    'keyserver.ubuntu.com'
      key          '0E27C0A6'
    end
  when 'debian'
    apt_repository 'saltstack-salt' do
      uri          'http://debian.saltstack.com/debian'
      distribution "#{node['lsb']['codename']}-saltstack"
      components   ['main']
      key          'http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key'
    end
  end
when 'rhel'
  minor_ver = node['salt']['version'] ? "archive/#{node['salt']['version'].split('-')[0]}" : 'latest'
  gpg_keyname = node['platform_version'].to_i == 5 ? 'SALTSTACK-EL5-GPG-KEY' : 'SALTSTACK-GPG-KEY'

  yum_repository 'saltstack-repo' do
    description 'SaltStack repo for Red Hat Enterprise Linux $releasever'
    baseurl "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{minor_ver}"
    gpgkey "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{minor_ver}/#{gpg_keyname}.pub"
    action :create
  end
end
