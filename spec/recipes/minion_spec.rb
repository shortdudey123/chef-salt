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
          chef_environment: '_default',
          config: {
            'id' => 'chefspec.local',
            'grains' => {},
            'ipv6' => false,
            'user' => 'root',
            'master_port' => 4506,
            'pidfile' => '/var/run/salt-minion.pid',
            'root_dir' => '/',
            'pki_dir' => '/etc/salt/pki/minion',
            'cachedir' => '/var/cache/salt/minion',
            'verify_env' => true,
            'auth_timeout' => 60,
            'loop_interval' => 60,
            'color' => true,
            'strip_colors' => false,
            'sock_dir' => '/var/run/salt/minion',
            'open_mode' => false,
            'permissive_pki_access' => false,
            'state_verbose' => true,
            'state_output' => 'full',
            'hash_type' => 'md5',
            'log_file' => '/var/log/salt/minion',
            'key_logfile' => '/var/log/salt/key',
            'log_level' => 'warning',
            'log_level_logfile' => 'warning',
            'log_datefmt' => "'%H:%M:%S'",
            'log_datefmt_logfile' => "'%Y-%m-%d %H:%M:%S'",
            'log_fmt_console' => "'[%(levelname)-8s] %(message)s'",
            'log_fmt_logfile' => "'%(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s'",
            'return' => 'mysql'
          },
          master: %w(127.0.0.1),
          roles: []
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
