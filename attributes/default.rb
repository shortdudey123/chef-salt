
default['salt']['version'] = nil # default: latest
default['salt']['setup']['configure_repo'] = true

default['salt']['role']['master'] = 'salt_master'
default['salt']['role']['minion'] = 'salt_minion'

default['salt']['key_accept_method'] = 'pub_key_sync' # options: pub_key_sync, api_key_accept
