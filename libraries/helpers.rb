require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'mixlib/log'

module SaltCookbookHelper
  def salt_config(config)
    config.to_hash.compact.sorted_hash.to_yaml
  end
end

class Hash
  # adapted from http://bdunagan.com/2011/10/23/ruby-tip-sort-a-hash-recursively/
  def sorted_hash(&block)
    self.class[
      each do |k, v|
        if v.class == Hash
          self[k] = v.sorted_hash(&block)
        elsif v.class == Array
          s = v.collect do |a|
            if a.respond_to?(:sorted_hash)
              a.sorted_hash(&block)
            elsif a.respond_to?(:sort)
              a.sort(&block)
            else
              a
            end
          end
          self[k] = s.sort.to_a
        end
      end.sort(&block)]
  end

  # from https://github.com/sunggun-yu/chef-mongodb3/blob/master/libraries/mongodb3_helper.rb
  def compact
    each_with_object({}) do |(k, v), new_hash|
      if v.is_a?(Hash)
        v = v.compact
        new_hash[k] = v unless v.empty?
      else
        new_hash[k] = v unless v.nil?
      end
      new_hash
    end
  end
end

def salt_key_check
  # check minion key
  if Mixlib::ShellOut.new('salt-call test.ping | grep -o True').run_command.exitstatus == 0
    Chef::Log.info('salt-call test.ping passed')
  else
    Chef::Log.info('salt-call test.ping failed')
    salt_accept_key
  end
end

def salt_accept_key
  # make api call to salt master
  # to accept minion key
  require 'salt/api'
  password = (node['salt']['key_accept_method'] == 'api_key_accept' ? Chef::EncryptedDataBagItem.load(node['salt']['minion']['master_api']['databag']['name'], node['salt']['minion']['master_api']['databag']['item'])[node['salt']['minion']['master_api']['databag']['key']] : nil) || raise('unable to determine password')

  (eauth = node['salt']['minion']['master_api']['eauth']) || 'pam'
  (username = node['salt']['minion']['master_api']['username']) || raise('must provide username')
  (minion = node['salt']['minion']['config']['id']) || raise('must provide minion')
  (host = node['salt']['minion']['master_api']['host']) || raise('must provide host')
  (port = node['salt']['minion']['master_api']['port']) || raise('must provide port')
  (use_ssl = node['salt']['minion']['master_api']['use_ssl']) || false

  Salt::Api.configure do |config|
    config.hostname = host
    config.port = port
    config.username = username
    config.password = password
    config.eauth = eauth
    config.use_ssl = use_ssl
  end

  accept_data = { 'fun' => 'key.accept', 'client' => 'wheel', 'tgt' => '*', 'match' => minion }

  begin
    Salt::Api.run(accept_data)
  rescue => error
    Chef::Log.warn('failed minion key accept attempt, got error')
    Chef::Log.warn(error)
  end
end
