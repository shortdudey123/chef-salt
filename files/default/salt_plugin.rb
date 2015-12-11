Ohai.plugin(:Salt) do
  provides 'salt'

  collect_data(:default) do
    salt Mash.new

    if File.exist? '/etc/salt/pki/minion/minion.pub'
      salt[:public_key] = IO.read('/etc/salt/pki/minion/minion.pub')
    elsif File.exist? '/etc/salt/pki/master/master.pub'
      salt[:public_key] = IO.read('/etc/salt/pki/master/master.pub')
    end
  end
end
