require 'spec_helper'

describe 'salt::default' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  end
end
