name              'salt'
maintainer        'Daryl Robbins'
maintainer_email  'daryl@robbins.name'
license           'Apache 2.0'
description       'Installs and configures Salt'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          	'1.1.0'

recipe 'salt::master', 'Installs and configures a Salt master'
recipe 'salt::minion', 'Installs and configures a Salt minion'

supports 'ubuntu', '>= 10.04'
supports 'fedora', '>= 19.0'
supports 'debian', '~> 7.0'

%w(redhat centos scientific amazon oracle).each do |os|
  supports os, '>= 5.0'
end

depends 'apt',              '~> 2.3.10'
depends 'yum',              '~> 3.0'
depends 'yum-epel'
depends 'ohai'

attribute "salt/version",
	:display_name => "Salt Version",
	:description =>
	"The version of Salt that will be installed. Leave blank (or 'nil') for latest.",
	:required => "optional",
	:recipes => [
	'salt::master',
	'salt::minion'
	]

attribute "salt/role/master",
	:display_name => "Salt Master Role",
	:description =>
	"The role representing a Salt Master. Defaults to 'salt_master'.",
	:required => "optional",
	:recipes => [
	'salt::master',
	'salt::minion'
	]

attribute "salt/role/minion",
	:display_name => "Salt Minion Role",
	:description =>
	"The role representing a Salt Minion. Defaults to 'salt_minion'.",
	:required => "optional",
	:recipes => [
	'salt::master',
	'salt::minion'
	]

attribute "salt/minion/master",
	:display_name => "List of Masters",
	:description =>
	"The address or list of Masters to use. If left blank, will use built-in search functionality.",
	:required => "optional",
	:recipes => [
	'salt::minion'
	]	

attribute "salt/minion/environment",
	:display_name => "Salt Environment",
	:description =>
	"The environment in which to search for master(s). If left blank, all environments will be searched. Defaults to the node's environment.",
	:required => "optional",
	:recipes => [
	'salt::minion'
	]	

attribute "salt/minion/grains",
	:display_name => "Salt Grains",
	:description =>
	"Map of custom grains for tagging the minion. Each entry may contain a single string value or a list of strings.",
	:required => "optional",
	:recipes => [
	'salt::minion'
	]		

attribute "salt/master/environment",
	:display_name => "Salt Environment",
	:description =>
	"The environment in which to search for minions. If left blank, all environments will be searched. Defaults to the node's environment.",
	:required => "optional",
	:recipes => [
	'salt::master'
	]	
