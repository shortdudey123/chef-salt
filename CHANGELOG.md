# CHANGELOG for Salt Cookbook

This file is used to list changes made in each version of the Salt Cookbook

## 1.1.0
* [Issue #4](https://github.com/darylrobbins/chef-salt/issues/4): Fixed master/minion search to use role instead of roles filter
* [PR2](https://github.com/darylrobbins/chef-salt/pull/3):Added `node['salt']['minion']['install_opts']` and `node['salt']['master']['install_opts']` for optionally providing package install options (Thanks to [jsanghi](https://github.com/jsanghi))

## 1.0.0
* Add support for key exchange between minions and master
* `node['salt']['minion']['master_environment']` has been renamed to `node['salt']['minion']['environment']` now that the master end of the discovery process has been implemented.

