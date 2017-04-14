require 'spec_helper'

describe 'salt::repo' do
  before do
    global_stubs_include_recipe
  end

  context 'ubuntu with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'creates saltstack-salt apt repository' do
      expect(chef_run).to add_apt_repository('saltstack-salt').with(
        uri: 'https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest',
        distribution: 'xenial',
        components: %w(main),
        key: 'https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub'
      )
    end
  end

  context 'ubuntu with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '15.04').converge(described_recipe) }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'creates saltstack-salt apt repository' do
      expect(chef_run).to add_apt_repository('saltstack-salt').with(
        uri: 'https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest',
        distribution: 'trusty',
        components: %w(main),
        key: 'https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub'
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

  context 'centos with default node attributes' do
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
