
Description
===========

> Because every Chef needs a little Salt.

*Improved Remote Execution for Open Source Chef*

Install [Salt](http://www.saltstack.com) master and/or minion.

### Why would anyone ever want to use both Salt and Chef?

I'm glad you asked!

Open Source Chef is weak in one key area that Salt just so happens to be very
strong: remote execution. `knife ssh "name:*" "sudo chef-client"` really doesn't
scale very well.

Think of Salt as the Push Jobs plugin for Open Source Chef. They're even based
on the same basic messaging technology: ZeroMQ.

And as of SaltStack 2014.7, they have significantly improved [Chef integration](http://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.chef.html#module-salt.modules.chef).
Want to do a chef client run on all your nodes: `salt "*" chef.client` Then, you
can use the job management commands to check on the status of your run.

And since you made or are hopefully about to make the wise decision to use this
cookbook, you'll get even better Chef-Salt integration. The cookbook will
automatically sync up the metadata (grains in Salt parlance) between Chef and
Salt to allow you to filter on role or environment or custom markers.

Requirements
============

### Platforms

This cooked has been confirmed to work on:

* Ubuntu 10.04 or later
* CentOS 5+, RedHat 5+, Scientific Linux 5+
* Fedora 19, 20
* Debian 7 (Wheezy)

### Dependencies

* apt
* yum
* yum-epel

Attributes
==========

* `node['salt']['version']` - Package version to be installed (defaults to nil for latest). This attribute applies to both the master and minion, since you'll want to keep their versions synced up
* `node['salt']['role']['master']` - Salt master role (defaults to salt_master)
* `node['salt']['role']['minion']` - Salt minion role (defaults to salt_minion)

### Minion
* `node['salt']['minion']['master']` - Address or list of masters, if not using built-in search functionality.
* `node['salt']['minion']['environment']` - The environment in which to search for a master; or `nil` to search all environments (defaults to the node's environment)
* `node['salt']['minion']['grains']` - Map of custom [grains](http://docs.saltstack.com/en/latest/topics/targeting/grains.html) for tagging the minion. Each entry may contain a single string value or a list of strings.
* `node['salt']['minion']['config_cookbook']` and `node['salt']['minion']['config_template']` allow you to override the template used to generate the minion config file `/etc/salt/minion`
* `node['salt']['minion']['install_opts']` allows you to specify install options for the package install statement (ex. '--nogpgcheck', but defaults to nil)

### Master
* `node['salt']['minion']['environment']` - The environment in which to search for minions; or `nil` to search all environments (defaults to the node's environment)
* `node['salt']['master']['config_cookbook']` and `node['salt']['master']['config_template']` allow you to override the template used to generate the master config file `/etc/salt/master`
* `node['salt']['master']['install_opts']` allows you to specify install options for the package install statement (ex. '--nogpgcheck', but defaults to nil)

See attribute files for more supported attributes.

Recipes
=======

default
-------

Nothing; reserved to include future LWRPs.

master
------

Install Salt master using OS package manager.

minion
------

Install Salt master using OS package manager.


Resources/Providers
===================

None at this time.

Usage
=====

Define two roles named salt_master and salt_minion, which include the corresponding
recipes. The nodes will automatically discover each other within the same environment
(when using Chef Server).

If you want your Salt Masters to operate across all environments, set
`node['salt']['minion']['environment']` to `nil` for all minions; and set 
`node['salt']['master']['environment']` to `nil` for all masters.

The cookbook will automatically manage the key exchange between minions and masters.
Note that once a new minion is setup, it will still be unable to communicate with the master(s)
until the next Chef run on the master(s). The minion recipe registers the minion's public key
and the master recipe then accepts any new keys that are registered with Chef.

Using Salt
==========

### Targetting Minions

This cookbook attempts to keep metadata synchronized between Chef and Salt.

Minions are automatically tagged (and updated on every chef-client run) with the
following two standard Salt [grains](http://docs.saltstack.com/en/latest/topics/targeting/grains.html):

* *environment* contains the chef environment of the node: `salt -G "environment:production" ...`
* *role* contains a complete expanded list of roles assigned to the node (this includes roles within roles): `salt -G "role:salt_minion" ...`

In addition, you can define your own custom grains using the `node['salt']['minion']['grains']` attribute. See above.

License and Author
==================

Author:: Daryl Robbins

Copyright:: 2014, Daryl Robbins

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
