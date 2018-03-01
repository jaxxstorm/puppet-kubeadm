# == Class kubeadm::configure
#
# @summary This class is called from kubeadm::init to install the config file.
#
# == Parameters
#
# @param config_hash Hash for kubeadm to be deployed as JSON
#
# @param purge If set will make puppet remove stale config files.
#
class kubeadm::configure(
  $config_hash,
  $purge = true,
) {

  file { $kubeadm::config_dir:
    ensure  => directory,
    purge   => $purge,
    recurse => $purge,
  }
  -> file { 'kubeadm config.json':
    ensure  => present,
    path    => "${kubeadm::config_dir}/config.json",
    content => kubeadm_sorted_json($config_hash, $::kubeadm::pretty_config, $::kubeadm::pretty_config_indent),
    require => File[$::kubeadm::config_dir],
  }


}
