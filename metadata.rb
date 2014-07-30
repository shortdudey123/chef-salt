name              'salt'
maintainer        'Daryl Robbins'
maintainer_email  'daryl@robbins.name'
license           'Apache 2.0'
description       'Installs and configures Salt'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

recipe 'master', 'Installs and configures a Salt master'
recipe 'minion', 'Installs and configures a Salt minion'

supports 'ubuntu', '>= 10.04'

%w(redhat centos scientific amazon oracle).each do |os|
  supports os, '>= 5.0'
end

depends 'apt',              '~> 2.3.10'
depends 'yum',              '~> 3.0'
depends 'yum-epel'