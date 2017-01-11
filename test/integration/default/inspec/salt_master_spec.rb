title 'Salt Master'

describe package('salt-master') do
  it { should be_installed }
end

# Service check not supported in RedHat 5, however we still have the proccess check
unless os[:family] == 'redhat' && os[:release] =~ /^5\./
  describe service('salt-master') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe service('salt-master') do
  it { should be_running }
end

describe file('/etc/salt/master') do
  it { should be_file }
  its(:content) { should match(/^interface: 0.0.0.0/) }
end

describe port(4505) do
  it { should be_listening }
  its('protocols') { should eq ['tcp'] }
end

describe port(4506) do
  it { should be_listening }
  its('protocols') { should eq ['tcp'] }
end
