require 'spec_helper'

describe 'salt::master' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe salt::_setup' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('salt::_setup')
      chef_run
    end

    it 'install salt-master' do
      expect(chef_run).to install_package('salt-master').with(
        version: nil,
        options: nil
      )
    end

    it 'enable salt-master service' do
      expect(chef_run).to enable_service('salt-master')
    end

    it 'create /etc/salt/master template' do
      expect(chef_run).to create_template('/etc/salt/master').with(
        source: 'master.erb',
        cookbook: 'salt',
        owner: 'root',
        group: 'root',
        mode: '0644',
        variables: {
          config: {},
        }
      )
    end

    it 'enable salt-master service' do
      expect(chef_run).to write_log('Salt key exchange not supported on Chef solo').with(
        level: :warn
      )
    end

    it 'wait for salt-master to start' do
      expect(chef_run).to_not run_execute('wait for salt-master').with(
        command: 'sleep 5'
      )
    end

    it 'should stub ohai salt for chefspec' do
      expect(chef_run).to_not reload_ohai('salt')
    end
  end

  context 'with master api enable true' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['salt']['master']['api']['enable'] = true
      end.converge(described_recipe)
    end

    it 'create /etc/salt/master template' do
      expect(chef_run).to create_template('/etc/salt/master').with(
        source: 'master.erb',
        cookbook: 'salt',
        owner: 'root',
        group: 'root',
        mode: '0644',
        variables: {
          config: {
            'rest_cherrypy' => {
              'disable_ssl' => true,
              'port' => 8000,
            },
          },
        }
      )
    end

    it 'install salt-api' do
      expect(chef_run).to install_package('salt-api').with(
        version: nil,
        options: nil
      )
    end

    it 'enable salt-api service' do
      expect(chef_run).to enable_service('salt-api')
    end
  end
end
