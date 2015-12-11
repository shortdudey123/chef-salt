require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe 'Salt Key Exchange' do
  describe command('salt-key --list=pre') do
    its(:stdout) { should match(/default-/) }
  end
end

describe 'Salt Master' do
  describe package('salt-master') do
    it { should be_installed }
  end

  # Service check not supported in RedHat 5, however we still have the proccess check
  unless os[:family] == 'RedHat' && os[:release] =~ /^5\./
    describe service('salt-master') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe process('salt-master') do
    it { should be_running }
  end

  describe file('/etc/salt/master') do
    it { should be_file }
    it { should contain 'interface: 0.0.0.0' }
  end

  describe port(4505) do
    it { should be_listening.with('tcp') }
  end

  describe port(4506) do
    it { should be_listening.with('tcp') }
  end
end

describe 'Salt Minion' do
  describe package('salt-minion') do
    it { should be_installed }
  end

  # Service check not supported in RedHat 5, however we still have the proccess check
  unless os[:family] == 'RedHat' && os[:release] =~ /^5\./
    describe service('salt-minion') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe process('salt-minion') do
    it { should be_running }
  end

  describe file('/etc/salt/minion') do
    it { should be_file }
    it { should contain 'master: 127.0.0.1' }
    its(:content) { should match(/id: default-/) }
    it { should contain 'environment: _default' }
    it { should contain '- salt_minion' }
    it { should contain 'quinoa: delicious' }
    it { should contain 'stooges:' }
    it { should contain '- moe' }
  end
end
