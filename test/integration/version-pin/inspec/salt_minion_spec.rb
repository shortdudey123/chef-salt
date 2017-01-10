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
  its(:content) { should match(/id: version-pin-/) }
  its(:content) { should match(/^  environment: _default/) }
  its(:content) { should match(/^  - salt_minion/) }
  its(:content) { should match(/^  quinoa: delicious/) }
  its(:content) { should match(/^  stooges:/) }
  its(:content) { should match(/^  - moe/) }
  its(:content) { should match(/^ipv6: false/) }
  its(:content) { should match(/^user: root/) }
  its(:content) { should match(/^master_port: 4506/) }
  its(:content) { should match %r{^pidfile: "/var/run/salt-minion.pid"} }
  its(:content) { should match %r{^root_dir: "/"} }
  its(:content) { should match %r{^pki_dir: "/etc/salt/pki/minion"} }
  its(:content) { should match %r{^cachedir: "/var/cache/salt/minion"} }
  its(:content) { should match(/^verify_env: true/) }
  its(:content) { should match(/^auth_timeout: 60/) }
  its(:content) { should match(/^loop_interval: 60/) }
  its(:content) { should match(/^color: true/) }
  its(:content) { should match(/^strip_colors: false/) }
  its(:content) { should match %r{^sock_dir: "/var/run/salt/minion"} }
  its(:content) { should match(/^open_mode: false/) }
  its(:content) { should match(/^permissive_pki_access: false/) }
  its(:content) { should match(/^state_verbose: true/) }
  its(:content) { should match(/^state_output: full/) }
  its(:content) { should match(/^hash_type: md5/) }
  its(:content) { should match %r{^log_file: "/var/log/salt/minion"} }
  its(:content) { should match %r{^key_logfile: "/var/log/salt/key"} }
  its(:content) { should match(/^log_level: warning/) }
  its(:content) { should match(/^log_level_logfile: warning/) }
  its(:content) { should match(/^log_datefmt: "%H:%M:%S"/) }
  its(:content) { should match(/^log_datefmt_logfile: "%Y-%m-%d %H:%M:%S"/) }
  its(:content) { should match(/^log_fmt_console: "\[%\(levelname\)-8s\] %\(message\)s"/) }
  its(:content) { should match(/^log_fmt_logfile: "%\(asctime\)s,%\(msecs\)03.0f \[%\(name\)-17s\]\[%\(levelname\)-8s\] %\(message\)s"/) }
  its(:content) { should match(/^return: mysql/) }
end
