module Puppet::Parser::Functions
  # Transforms a hash into a string of flags
  newfunction(:kubeadm_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << "--config '#{opts['config']}'" if opts['config'].to_s != 'undef'
    flags << "--ignore-preflight-errors='#{opts['ignore_preflight_errors'].join(',')}'" if opts['ignore_preflight_errors'].to_s != 'undef'

    flags.flatten.join(' ')
  end
end
