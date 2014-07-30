
include_recipe 'salt::default'

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'saltstack-salt' do
    uri          'http://ppa.launchpad.net/saltstack/salt/ubuntu'
    distribution node['lsb']['codename']
    components   ['main']
    keyserver    'keyserver.ubuntu.com'
    key          '0E27C0A6'
  end

when 'rhel'
  if node['platform_version'].to_i >= 5
    include_recipe 'yum-epel'
  end

end