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
  yum_repository 'saltstack-repo' do
    description 'SaltStack repo for Red Hat Enterprise Linux $releasever'
    baseurl "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{minor_ver}"
    gpgkey "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{minor_ver}/SALTSTACK-GPG-KEY.pub"
    action :create
  end
end
