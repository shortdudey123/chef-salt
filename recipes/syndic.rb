#
# Cookbook Name:: chef-salt
# Recipe:: syndic
#
# Copyright (C) 2016, Grant Ridder
# Copyright (C) 2014, Daryl Robbins
#
#
#

include_recipe 'salt::_setup'

package 'salt-syndic' do
  action :install
end
