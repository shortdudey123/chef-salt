require 'spec_helper'

describe 'salt::minion' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'raises an exception with the correct message' do
      expect { raise chef_run }.to raise_error { |error|
        expect(error).to be_a(RuntimeError)
        expect(error.message).to eq('No salt-master found')
      }
    end
  end

  context 'with master attribute set' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['salt']['minion']['master'] = '127.0.0.1'
      end.converge(described_recipe)
    end

    it 'should include recipe salt::_setup' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('salt::_setup')
      chef_run
    end

    it 'install salt-minion' do
      expect(chef_run).to install_package('salt-minion').with(
        version: nil,
        options: nil
      )
    end

    it 'enable salt-minion service' do
      expect(chef_run).to enable_service('salt-minion')
    end

    it 'create /etc/salt/minion template' do
      expect(chef_run).to create_template('/etc/salt/minion').with(
        source: 'minion.erb',
        cookbook: 'salt',
        owner: 'root',
        group: 'root',
        mode: '0644',
        variables: {
          config: {
            'id' => 'fauxhai.local',
            'grains' => {
              'environment' => '_default',
              'role' => [],
            },
            'master' => %w(127.0.0.1),
          },
        }
      )
      expect(chef_run.template('/etc/salt/minion')).to notify('service[salt-minion]').to(:restart).delayed
      expect(chef_run.template('/etc/salt/minion')).to notify('execute[wait for salt-minion]').to(:run).delayed
    end

    it 'wait for salt-minion to start' do
      expect(chef_run).to_not run_execute('wait for salt-minion').with(
        command: 'sleep 5'
      )
    end

    it 'should stub ohai salt for chefspec' do
      expect(chef_run).to_not reload_ohai('salt')
    end
  end
end
