#
# Cookbook Name:: chef-salt
# Recipe:: repo
#
# Copyright (C) 2016, Grant Ridder
# Copyright (C) 2014, Daryl Robbins
#
#
#

minor_ver = if node['salt']['version'].nil?
              'latest'
            elsif node['salt']['version'].split('-')[0].split('.').length == 2
              node['salt']['version'].split('-')[0].split('.')[0..1].join('.')
            elsif node['salt']['version'].split('-')[0].split('.').length == 3
              "archive/#{node['salt']['version'].split('-')[0]}"
            end

case node['platform_family']
when 'debian'
  # TODO: remove apt cookbook when dropping support for Chef < 12.9
  # apt_repository resource was added to Chef 12.9 so this will throw deprecation warnings
  # "WARN: Chef::Provider::AptRepository already exists!  Cannot create deprecation class for LWRP provider apt_repository from cookbook apt"
  # "WARN: AptRepository already exists!  Deprecation class overwrites Custom resource apt_repository from cookbook apt"
  include_recipe 'apt'

  case node['platform']
  when 'ubuntu'
    lts = if node['platform_version'].to_f < 14.04
            ['12.04', 'precise']
          elsif node['platform_version'].to_f < 16.04
            ['14.04', 'trusty']
          else
            ['16.04', 'xenial']
          end

    repo_uri = "https://repo.saltstack.com/apt/ubuntu/#{lts[0]}/amd64/#{minor_ver}"

    apt_repository 'saltstack-salt' do
      uri          repo_uri
      distribution lts[1]
      components   ['main']
      key          "#{repo_uri}/SALTSTACK-GPG-KEY.pub"
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
  gpg_keyname = node['platform_version'].to_i == 5 ? 'SALTSTACK-EL5-GPG-KEY' : 'SALTSTACK-GPG-KEY'

  yum_repository 'saltstack-repo' do
    description 'SaltStack repo for Red Hat Enterprise Linux $releasever'
    baseurl "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{minor_ver}"
    gpgkey "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{minor_ver}/#{gpg_keyname}.pub"
    action :create
  end
end
