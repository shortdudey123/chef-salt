require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe "Salt Key Exchange" do

  describe command('salt-key --list=pre') do
    its(:stdout) { should match /default-/ }
  end

end