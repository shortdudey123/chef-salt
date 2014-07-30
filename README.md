
Description
===========

> Because every Chef needs a little Salt.

Install [Salt](http://www.saltstack.com) master and/or minion.

Requirements
============

### Platforms

This cooked has been confirmed to work on:

* Ubuntu 10.04 or later
* CentOS 5+, RedHat 5+, Scientific Linux 5+

Note that Debian and Fedora are not currently suported (coming soon).

### Dependencies

* apt
* yum
* yum-epel

Attributes
==========

* `node['salt']['minion']['master']` - Address or list of masters, if not using built-in search functionality.

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


Usage
=====

Define two roles named salt_master and salt_minion, which include the corresponding
recipes. The nodes will automatically discover each other within the same environment
(when using Chef Server).

If you want your Salt Masters to operate across all environments, set
`node['salt']['minion']['master_environment']` to `nil` for all minions.

At the moment, you will need to [approve access](http://docs.saltstack.com/en/latest/ref/cli/salt-key.html) for any minions with the `salt-key -A` command. A future version of this cookbook
will handle this automatically.


Examples
--------

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