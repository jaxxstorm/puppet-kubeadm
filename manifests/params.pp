# == Class kubeadm::params
#
# @summary This class is meant to be called from kubeadm
# It sets variables according to platform
#
class kubeadm::params {

  $config_dir            = '/etc/kubeadm'
  $config_defaults       = {}
  $config_hash           = {}
  $manage_repos          = true
  $package_ensure        = 'latest'
  $package_name          = 'kubeadm'
  $pretty_config         = true
  $pretty_config_indent  = 4
  $purge_config_dir      = true


}
