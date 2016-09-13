# CHANGELOG for Salt Cookbook

This file is used to list changes made in each version of the Salt Cookbook

## Unreleased
- Remove CircleCI since TravisCI is already here
- Fix Ruby syntax
- Fix Chef syntax
- Remove apt and yum version locks
- Fix serverspec syntax
- Update test kitchen
- **[PR #9](https://github.com/shortdudey123/chef-salt/pull/9)** - Update config file comments
- **[PR #10](https://github.com/shortdudey123/chef-salt/pull/10)** - attribute all the configs
- **[PR #11](https://github.com/shortdudey123/chef-salt/pull/11)** - Fix ruby syntax on Vagrantfile
- **[PR #12](https://github.com/shortdudey123/chef-salt/pull/12)** - Add salt-api option to salt-master
- **[PR #13](https://github.com/shortdudey123/chef-salt/pull/13)** - Bump travis ruby version and cache bundler
- **[PR #14](https://github.com/shortdudey123/chef-salt/pull/14)** - if node['salt'] does not exist on a found node, skip
- **[PR #15](https://github.com/shortdudey123/chef-salt/pull/15)** - Switch event_return to nil by default
- **[PR #16](https://github.com/shortdudey123/chef-salt/pull/16)** - Update Ruby syntax per Rubocop v0.37.0
- **[PR #17](https://github.com/shortdudey123/chef-salt/pull/17)** - Update README.md
- **[PR #18](https://github.com/shortdudey123/chef-salt/pull/18)** - Add source_url and issues_url to metadata
- **[PR #19](https://github.com/shortdudey123/chef-salt/pull/19)** - Fix rubocop deprecated pattern style
- **[PR #21](https://github.com/shortdudey123/chef-salt/pull/21)** - Fix comment ordering in Vagrantfile
- **[PR #22](https://github.com/shortdudey123/chef-salt/pull/22)** - Update Ohai plugin to work with Ohai 4.x cookbook
- **[PR #23](https://github.com/shortdudey123/chef-salt/pull/23)** - Update test-kitchen OS's
- **[PR #24](https://github.com/shortdudey123/chef-salt/pull/24)** - update Berkshelf source
- **[PR #25](https://github.com/shortdudey123/chef-salt/pull/25)** - Switch RHEL repo from epel to saltstack oficial
- **[PR #26](https://github.com/shortdudey123/chef-salt/pull/26)** - Add Chefspec testing
- **[PR #27](https://github.com/shortdudey123/chef-salt/pull/27)** - Update Rubocop rules

## 1.1.0
* [Issue #4](https://github.com/darylrobbins/chef-salt/issues/4): Fixed master/minion search to use role instead of roles filter
* [PR2](https://github.com/darylrobbins/chef-salt/pull/3):Added `node['salt']['minion']['install_opts']` and `node['salt']['master']['install_opts']` for optionally providing package install options (Thanks to [jsanghi](https://github.com/jsanghi))

## 1.0.0
* Add support for key exchange between minions and master
* `node['salt']['minion']['master_environment']` has been renamed to `node['salt']['minion']['environment']` now that the master end of the discovery process has been implemented.

