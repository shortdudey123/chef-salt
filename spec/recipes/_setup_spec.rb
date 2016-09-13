require 'spec_helper'

describe 'salt::_setup' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe salt::default' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('salt::default')
      chef_run
    end

    it 'should include recipe ohai' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ohai')
      chef_run
    end

    it "should not create ohai['salt'] by default" do
      expect(chef_run).to_not reload_ohai('salt')
    end

    it 'should create salt ohai_plugin' do
      expect(chef_run).to create_ohai_plugin('salt').with(
        source_file: 'salt_plugin.rb'
      )
      expect(chef_run.ohai_plugin('salt')).to notify('ohai[salt]').to(:reload).immediately
    end
  end

  context 'ubuntu with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'creates saltstack-salt apt repository' do
      expect(chef_run).to add_apt_repository('saltstack-salt').with(
        uri: 'http://ppa.launchpad.net/saltstack/salt/ubuntu',
        distribution: 'xenial',
        components: %w(main),
        keyserver: 'keyserver.ubuntu.com',
        key: '0E27C0A6'
      )
    end
  end

  context 'debian with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'debian', version: '8.5').converge(described_recipe) }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'creates saltstack-salt apt repository' do
      expect(chef_run).to add_apt_repository('saltstack-salt').with(
        uri: 'http://debian.saltstack.com/debian',
        distribution: 'jessie-saltstack',
        components: %w(main),
        key: 'http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key'
      )
    end
  end

  context 'centos 5 with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '5.11').converge(described_recipe) }

    it 'creates saltstack-salt yum repository' do
      expect(chef_run).to create_yum_repository('saltstack-repo').with(
        description: 'SaltStack repo for Red Hat Enterprise Linux $releasever',
        baseurl: 'https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest',
        gpgkey: 'https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-EL5-GPG-KEY.pub'
      )
    end
  end

  context 'centos > 5 with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511').converge(described_recipe) }

    it 'creates saltstack-salt yum repository' do
      expect(chef_run).to create_yum_repository('saltstack-repo').with(
        description: 'SaltStack repo for Red Hat Enterprise Linux $releasever',
        baseurl: 'https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest',
        gpgkey: 'https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub'
      )
    end
  end
end
