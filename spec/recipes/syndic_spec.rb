require 'spec_helper'

describe 'salt::syndic' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe salt::_setup' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('salt::_setup')
      chef_run
    end

    it 'install salt-syndic package' do
      expect(chef_run).to install_package('salt-syndic')
    end
  end
end
