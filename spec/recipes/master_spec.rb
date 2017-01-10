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
          config: {
            'interface' => '0.0.0.0',
            'ipv6' => false,
            'publish_port' => 4505,
            'user' => 'root',
            'max_open_files' => 100000,
            'worker_threads' => 5,
            'ret_port' => 4506,
            'pidfile' => '/var/run/salt-master.pid',
            'root_dir' => '/',
            'pki_dir' => '/etc/salt/pki/master',
            'cachedir' => '/var/cache/salt/master',
            'verify_env' => true,
            'keep_jobs' => 24,
            'timeout' => 5,
            'loop_interval' => 60,
            'output' => 'nested',
            'show_timeout' => true,
            'color' => true,
            'strip_colors' => false,
            'sock_dir' => '/var/run/salt/master',
            'enable_gpu_grains' => false,
            'job_cache' => true,
            'minion_data_cache' => true,
            'event_return' => nil,
            'event_return_queue' => 0,
            'max_event_size' => 1048576,
            'ping_on_rotate' => false,
            'preserve_minion_cache' => false,
            'con_cache' => false,
            'open_mode' => false,
            'auto_accept' => false,
            'autosign_timeout' => 120,
            'autosign_file' => '/etc/salt/autosign.conf',
            'autoreject_file' => '/etc/salt/autoreject.conf',
            'permissive_pki_access' => false,
            'sudo_acl' => false,
            'token_expire' => 43200,
            'file_recv' => false,
            'file_recv_max_size' => 100,
            'sign_pub_messages' => false,
            'cython_enable' => false,
            'state_top' => 'top.sls',
            'renderer' => 'yaml_jinja',
            'jinja_lstrip_blocks' => false,
            'failhard' => false,
            'state_verbose' => true,
            'state_output' => 'full',
            'state_aggregate' => false,
            'state_events' => false,
            'hash_type' => 'md5',
            'file_buffer_size' => 1048576,
            'fileserver_events' => false,
            'log_file' => '/var/log/salt/master',
            'key_logfile' => '/var/log/salt/key',
            'log_level' => 'warning',
            'log_level_logfile' => 'warning',
            'log_datefmt' => '%H:%M:%S',
            'log_datefmt_logfile' => '%Y-%m-%d %H:%M:%S',
            'log_fmt_console' => '[%(levelname)-8s] %(message)s',
            'log_fmt_logfile' => '%(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s',
            'return' => 'mysql',
          },
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
            'interface' => '0.0.0.0',
            'ipv6' => false,
            'publish_port' => 4505,
            'user' => 'root',
            'max_open_files' => 100000,
            'worker_threads' => 5,
            'ret_port' => 4506,
            'pidfile' => '/var/run/salt-master.pid',
            'root_dir' => '/',
            'pki_dir' => '/etc/salt/pki/master',
            'cachedir' => '/var/cache/salt/master',
            'verify_env' => true,
            'keep_jobs' => 24,
            'timeout' => 5,
            'loop_interval' => 60,
            'output' => 'nested',
            'show_timeout' => true,
            'color' => true,
            'strip_colors' => false,
            'sock_dir' => '/var/run/salt/master',
            'enable_gpu_grains' => false,
            'job_cache' => true,
            'minion_data_cache' => true,
            'event_return' => nil,
            'event_return_queue' => 0,
            'max_event_size' => 1048576,
            'ping_on_rotate' => false,
            'preserve_minion_cache' => false,
            'con_cache' => false,
            'open_mode' => false,
            'auto_accept' => false,
            'autosign_timeout' => 120,
            'autosign_file' => '/etc/salt/autosign.conf',
            'autoreject_file' => '/etc/salt/autoreject.conf',
            'permissive_pki_access' => false,
            'sudo_acl' => false,
            'token_expire' => 43200,
            'file_recv' => false,
            'file_recv_max_size' => 100,
            'sign_pub_messages' => false,
            'cython_enable' => false,
            'state_top' => 'top.sls',
            'renderer' => 'yaml_jinja',
            'jinja_lstrip_blocks' => false,
            'failhard' => false,
            'state_verbose' => true,
            'state_output' => 'full',
            'state_aggregate' => false,
            'state_events' => false,
            'hash_type' => 'md5',
            'file_buffer_size' => 1048576,
            'fileserver_events' => false,
            'log_file' => '/var/log/salt/master',
            'key_logfile' => '/var/log/salt/key',
            'log_level' => 'warning',
            'log_level_logfile' => 'warning',
            'log_datefmt' => '%H:%M:%S',
            'log_datefmt_logfile' => '%Y-%m-%d %H:%M:%S',
            'log_fmt_console' => '[%(levelname)-8s] %(message)s',
            'log_fmt_logfile' => '%(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s',
            'return' => 'mysql',
            'rest_cherrypy' => {
              'collect_stats' => false,
              'debug' => false,
              'disable_ssl' => true,
              'expire_responses' => true,
              'host' => '0.0.0.0',
              'max_request_body_size' => 1048576,
              'port' => 8000,
              'socket_queue_size' => 30,
              'ssl_crt' => nil,
              'ssl_key' => nil,
              'thread_pool' => 100,
              'webhook_disable_auth' => false,
              'webhook_url' => '/hook',
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
