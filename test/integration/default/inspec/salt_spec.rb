title 'Salt'

describe command('salt-key --list=pre') do
  its(:stdout) { should match(/default-/) }
end

base_dir = ENV['CI'] ? 'opt' : 'tmp'
describe file("/#{base_dir}/kitchen/ohai/plugins/salt.rb") do
  it { should be_file }
  its(:content) { should match(/^Ohai.plugin\(:Salt\) do\n/) }
end
