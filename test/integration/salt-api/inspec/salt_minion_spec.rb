title 'Salt Minion'

describe package('salt-minion') do
  it { should be_installed }
end

# Service check not supported in RedHat 5, however we still have the proccess check
unless os[:family] == 'redhat' && os[:release] =~ /^5\./
  describe service('salt-minion') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe service('salt-minion') do
  it { should be_running }
end

describe file('/etc/salt/minion') do
  it { should be_file }
  its(:content) { should match(/^master:\n- 127.0.0.1/) }
  its(:content) { should match(/id: salt-api-/) }
  its(:content) { should match(/^  environment: _default/) }
  its(:content) { should match(/^  - salt_minion/) }
  its(:content) { should match(/^  quinoa: delicious/) }
  its(:content) { should match(/^  stooges:/) }
  its(:content) { should match(/^  - moe/) }
end
