require 'spec_helper'

describe 'salt::_setup' do
  before do
    global_stubs_include_recipe
  end

  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should include recipe salt::default' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('salt::default')
    chef_run
  end

  it 'should include recipe ohai' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ohai')
    chef_run
  end

  it "should not create ohai['salt'] by default" do
    expect(chef_run).to_not reload_ohai('salt')
  end

  it 'should create salt ohai_plugin' do
    expect(chef_run).to create_ohai_plugin('salt').with(source_file: 'salt_plugin.rb')
    expect(chef_run.ohai_plugin('salt')).to notify('ohai[salt]').to(:reload).immediately
  end

  it 'should include recipe salt::repo' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('salt::repo')
    chef_run
  end
end
