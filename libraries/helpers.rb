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

def salt_accept_key(options)
  (eauth = options['eauth']) || 'pam'
  (username = options['username']) || raise('must provide username')
  (password = options['password']) || raise('must provide password')
  (minion = options['minion']) || raise('must provide minion')
  (host = options['host']) || raise('must provide host')
  (port = options['port']) || raise('must provide port')

  headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  login_data = { 'username' => username, 'password' => password, 'eauth' => eauth }.to_json
  accept_data = { 'fun' => 'key.accept', 'client' => 'wheel', 'tgt' => '*', 'match' => minion }.to_json

  begin
    Chef::Log.info("Connecting to host=#{host}, port=#{port}, use_ssl=#{options['use_ssl']}, verify=#{options['verify']}")

    https = Net::HTTP.new(host, port)
    https.use_ssl = options['use_ssl']
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE unless options['verify']

    login = https.post('/login', login_data, headers)

    if login.code == '200'
      cookie = login.response['set-cookie'].split('; ')[0]
      headers['Cookie'] = cookie

      accept = https.post('/', accept_data, headers)
      if accept.code == '200'
        minions = JSON.parse(accept.body)['return'][0]['data']['return']['minions']

        if minions && minions.include?(minion)
          Chef::Log.info("accepted key for minion #{minion}")
        else
          Chef::Log.warn("failed to accept key for minion #{minion}, check minion key status on master")
        end
      else
        Chef::Log.warn("failed to accept minion key, got http respose code #{accept.code}")
        Chef::Log.warn(accept.body)
      end
    else
      Chef::Log.warn("failed to login, got http response code #{login.code}")
      Chef::Log.warn(login.body)
    end
  rescue => error
    Chef::Log.warn('failed minion key accept attempt, got error')
    Chef::Log.warn(error)
  end
end
