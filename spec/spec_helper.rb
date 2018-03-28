require 'puppetlabs_spec_helper/module_spec_helper'

if ENV['PUPPET_DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end
