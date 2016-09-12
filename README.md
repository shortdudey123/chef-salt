# Salt Cookbook

[![Build Status](https://travis-ci.org/shortdudey123/chef-salt.svg)](https://travis-ci.org/shortdudey123/chef-salt)

> Because every Chef needs a little Salt.

*Improved Remote Execution for Open Source Chef*

Install [Salt](http://www.saltstack.com) master and/or minion.

## Why would anyone ever want to use both Salt and Chef?

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

## Requirements

### Platforms

This cooked has been confirmed to work on:

* Ubuntu 12.04 or later
* CentOS 5+, RedHat 5+, Scientific Linux 5+
* Fedora 19 (minion only), 20, 21
* Debian 7+ (Wheezy)

### Dependencies

* apt
* yum
* yum-epel

## Attributes

## Deprecated
* `node['salt']['minion']['grains']` - **DEPRECATED** replaced by `node['salt']['minion']['config']['grains']`
* `node['salt']['minion']['id']` - **DEPRECATED** replaced by `node['salt']['minion']['config']['id']`
* `node['salt']['master']['interface']` - **DEPRECATED** replaced by `node['salt']['master']['config']['interface']`

### General
* `node['salt']['version']` - Package version to be installed (defaults to nil for latest). This attribute applies to both the master and minion, since you'll want to keep their versions synced up
* `node['salt']['role']['master']` - Salt master role (defaults to salt_master)
* `node['salt']['role']['minion']` - Salt minion role (defaults to salt_minion)

### Minion
* `node['salt']['minion']['master']` - Address or list of masters, if not using built-in search functionality.
* `node['salt']['minion']['environment']` - The environment in which to search for a master; or `nil` to search all environments (defaults to the node's environment)
* `node['salt']['minion']['grains']` - **DEPRECATED** replaced by `node['salt']['minion']['config']['grains']`
* `node['salt']['minion']['config_cookbook']` and `node['salt']['minion']['config_template']` allow you to override the template used to generate the minion config file `/etc/salt/minion`
* `node['salt']['minion']['install_opts']` allows you to specify install options for the package install statement (ex. '--nogpgcheck', but defaults to nil)
* `node['salt']['minion']['id']` - **DEPRECATED** replaced by `node['salt']['minion']['config']['id']`
* `node['salt']['minion']['config']['id']` - (defaults to node.name)
* `node['salt']['minion']['config']['grains']` - Map of custom [grains](http://docs.saltstack.com/en/latest/topics/targeting/grains.html) for tagging the minion. Each entry may contain a single string value or a list of strings. (defaults to {})
* `node['salt']['minion']['config']['ipv6']` - (defaults to `false`)
* `node['salt']['minion']['config']['user']` - (defaults to `root`)
* `node['salt']['minion']['config']['master_port']` - (defaults to `4506`)
* `node['salt']['minion']['config']['pidfile']` - (defaults to `/var/run/salt-minion.pid`)
* `node['salt']['minion']['config']['root_dir']` - (defaults to `/`)
* `node['salt']['minion']['config']['pki_dir']` - (defaults to `/etc/salt/pki/minion`)
* `node['salt']['minion']['config']['cachedir']` - (defaults to `/var/cache/salt/minion`)
* `node['salt']['minion']['config']['verify_env']` - (defaults to `true`)
* `node['salt']['minion']['config']['auth_timeout']` - (defaults to `60`)
* `node['salt']['minion']['config']['loop_interval']` - (defaults to `60`)
* `node['salt']['minion']['config']['color']` - (defaults to `true`)
* `node['salt']['minion']['config']['strip_colors']` - (defaults to `false`)
* `node['salt']['minion']['config']['sock_dir']` - (defaults to `/var/run/salt/minion`)
* `node['salt']['minion']['config']['open_mode']` - (defaults to `false`)
* `node['salt']['minion']['config']['permissive_pki_access']` - (defaults to `false`)
* `node['salt']['minion']['config']['state_verbose']` - (defaults to `true`)
* `node['salt']['minion']['config']['state_output']` - (defaults to `full`)
* `node['salt']['minion']['config']['hash_type']` - (defaults to `md5`)
* `node['salt']['minion']['config']['log_file']` - (defaults to `/var/log/salt/master`)
* `node['salt']['minion']['config']['key_logfile']` - (defaults to `/var/log/salt/key`)
* `node['salt']['minion']['config']['log_level']` - (defaults to `warning`)
* `node['salt']['minion']['config']['log_level_logfile']` - (defaults to `warning`)
* `node['salt']['minion']['config']['log_datefmt']` - (defaults to `'%H:%M:%S'`)
* `node['salt']['minion']['config']['log_datefmt_logfile']` - (defaults to `'%Y-%m-%d %H:%M:%S'`)
* `node['salt']['minion']['config']['log_fmt_console']` - (defaults to `'[%(levelname)-8s] %(message)s'`)
* `node['salt']['minion']['config']['log_fmt_logfile']` - (defaults to `'%(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s'`)
* `node['salt']['minion']['config']['return']` - (defaults to `mysql`)

### Master
* `node['salt']['master']['api']['enable']` - install salt-api package (defaults to `false`)
* `node['salt']['master']['api']['install_opts']` - (defaults to `nil`)
* `node['salt']['master']['api']['package']` - (defaults to `salt-api`)
* `node['salt']['master']['api']['config']['collect_stats']` - (defaults to `false`)
* `node['salt']['master']['api']['config']['debug']` - (defaults to `false`)
* `node['salt']['master']['api']['config']['disable_ssl']` - (defaults to `true`)
* `node['salt']['master']['api']['config']['expire_responses']` - (defaults to `true`)
* `node['salt']['master']['api']['config']['host']` - (defaults to `0.0.0.0`)
* `node['salt']['master']['api']['config']['max_request_body_size']` - (defaults to `1048576`)
* `node['salt']['master']['api']['config']['port']` - (defaults to `8000`)
* `node['salt']['master']['api']['config']['socket_queue_size']` - (defaults to `30`)
* `node['salt']['master']['api']['config']['ssl_crt']` - (defaults to `nil`)
* `node['salt']['master']['api']['config']['ssl_key']` - (defaults to `nil`)
* `node['salt']['master']['api']['config']['thread_pool']` - (defaults to `100`)
* `node['salt']['master']['api']['config']['webhook_disable_auth']` - (defaults to `false`)
* `node['salt']['master']['api']['config']['webhook_url']` - (defaults to `/hook`)
* `node['salt']['minion']['environment']` - The environment in which to search for minions; or `nil` to search all environments (defaults to the node's environment)
* `node['salt']['master']['config_cookbook']` and `node['salt']['master']['config_template']` allow you to override the template used to generate the master config file `/etc/salt/master`
* `node['salt']['master']['install_opts']` allows you to specify install options for the package install statement (ex. '--nogpgcheck', but defaults to nil)
* `node['salt']['master']['interface']` - **DEPRECATED** replaced by `node['salt']['master']['config']['interface']`
* `node['salt']['master']['config']['interface']` - (defaults to `0.0.0.0`)
* `node['salt']['master']['config']['ipv6']` - (defaults to `false`)
* `node['salt']['master']['config']['publish_port']` - (defaults to `4505`)
* `node['salt']['master']['config']['user']` - (defaults to `root`)
* `node['salt']['master']['config']['max_open_files']` - (defaults to `100000`)
* `node['salt']['master']['config']['worker_threads']` - (defaults to `5`)
* `node['salt']['master']['config']['ret_port']` - (defaults to `4506`)
* `node['salt']['master']['config']['pidfile']` - (defaults to `/var/run/salt-master.pid`)
* `node['salt']['master']['config']['root_dir']` - (defaults to `/`)
* `node['salt']['master']['config']['pki_dir']` - (defaults to `/etc/salt/pki/master`)
* `node['salt']['master']['config']['cachedir']` - (defaults to `/var/cache/salt/master`)
* `node['salt']['master']['config']['verify_env']` - (defaults to `true`)
* `node['salt']['master']['config']['keep_jobs']` - (defaults to `24`)
* `node['salt']['master']['config']['timeout']` - (defaults to `5`)
* `node['salt']['master']['config']['loop_interval']` - (defaults to `60`)
* `node['salt']['master']['config']['output']` - (defaults to `nested`)
* `node['salt']['master']['config']['show_timeout']` - (defaults to `true`)
* `node['salt']['master']['config']['color']` - (defaults to `true`)
* `node['salt']['master']['config']['strip_colors']` - (defaults to `false`)
* `node['salt']['master']['config']['sock_dir']` - (defaults to `/var/run/salt/master`)
* `node['salt']['master']['config']['enable_gpu_grains']` - (defaults to `false`)
* `node['salt']['master']['config']['job_cache']` - (defaults to `true`)
* `node['salt']['master']['config']['minion_data_cache']` - (defaults to `true`)
* `node['salt']['master']['config']['event_return']` - (defaults to `nil`)
* `node['salt']['master']['config']['event_return_queue']` - (defaults to `0`)
* `node['salt']['master']['config']['max_event_size']` - (defaults to `1048576`)
* `node['salt']['master']['config']['ping_on_rotate']` - (defaults to `false`)
* `node['salt']['master']['config']['preserve_minion_cache']` - (defaults to `false`)
* `node['salt']['master']['config']['con_cache']` - (defaults to `false`)
* `node['salt']['master']['config']['open_mode']` - (defaults to `false`)
* `node['salt']['master']['config']['auto_accept']` - (defaults to `false`)
* `node['salt']['master']['config']['autosign_timeout']` - (defaults to `120`)
* `node['salt']['master']['config']['autosign_file']` - (defaults to `/etc/salt/autosign.conf`)
* `node['salt']['master']['config']['autoreject_file']` - (defaults to `/etc/salt/autoreject.conf`)
* `node['salt']['master']['config']['permissive_pki_access']` - (defaults to `false`)
* `node['salt']['master']['config']['sudo_acl']` - (defaults to `false`)
* `node['salt']['master']['config']['token_expire']` - (defaults to `43200`)
* `node['salt']['master']['config']['file_recv']` - (defaults to `false`)
* `node['salt']['master']['config']['file_recv_max_size']` - (defaults to `100`)
* `node['salt']['master']['config']['sign_pub_messages']` - (defaults to `false`)
* `node['salt']['master']['config']['cython_enable']` - (defaults to `false`)
* `node['salt']['master']['config']['state_top']` - (defaults to `top.sls`)
* `node['salt']['master']['config']['renderer']` - (defaults to `yaml_jinja`)
* `node['salt']['master']['config']['jinja_lstrip_blocks']` - (defaults to `false`)
* `node['salt']['master']['config']['failhard']` - (defaults to `false`)
* `node['salt']['master']['config']['state_verbose']` - (defaults to `true`)
* `node['salt']['master']['config']['state_output']` - (defaults to `full`)
* `node['salt']['master']['config']['state_aggregate']` - (defaults to `false`)
* `node['salt']['master']['config']['state_events']` - (defaults to `false`)
* `node['salt']['master']['config']['hash_type']` - (defaults to `md5`)
* `node['salt']['master']['config']['file_buffer_size']` - (defaults to `1048576`)
* `node['salt']['master']['config']['fileserver_events']` - (defaults to `false`)
* `node['salt']['master']['config']['log_file']` - (defaults to `/var/log/salt/master`)
* `node['salt']['master']['config']['key_logfile']` - (defaults to `/var/log/salt/key`)
* `node['salt']['master']['config']['log_level']` - (defaults to `warning`)
* `node['salt']['master']['config']['log_level_logfile']` - (defaults to `warning`)
* `node['salt']['master']['config']['log_datefmt']` - (defaults to `'%H:%M:%S'`)
* `node['salt']['master']['config']['log_datefmt_logfile']` - (defaults to `'%Y-%m-%d %H:%M:%S'`)
* `node['salt']['master']['config']['log_fmt_console']` - (defaults to `'[%(levelname)-8s] %(message)s'`)
* `node['salt']['master']['config']['log_fmt_logfile']` - (defaults to `'%(asctime)s\`)%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s'`)
* `node['salt']['master']['config']['return']` - (defaults to `mysql`)

See attribute files for more supported attributes.

## Recipes

### default

Nothing; reserved to include future LWRPs.

### master

Install Salt master using OS package manager.

### minion

Install Salt minion using OS package manager.


## Resources/Providers

None at this time.

## Usage

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

## Using Salt

### Targetting Minions

This cookbook attempts to keep metadata synchronized between Chef and Salt.

Minions are automatically tagged (and updated on every chef-client run) with the
following two standard Salt [grains](http://docs.saltstack.com/en/latest/topics/targeting/grains.html):

* *environment* contains the chef environment of the node: `salt -G "environment:production" ...`
* *role* contains a complete expanded list of roles assigned to the node (this includes roles within roles): `salt -G "role:salt_minion" ...`

In addition, you can define your own custom grains using the `node['salt']['minion']['grains']` attribute. See above.

## License and Author

* Author:: Daryl Robbins
* Author:: Grant Ridder

Copyright:: 2015, Grant Ridder

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
