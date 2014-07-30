
include_recipe "salt::_setup"

package 'salt-syndic' do
  action :install
end