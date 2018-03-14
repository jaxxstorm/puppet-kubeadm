# == Class kubeadm::params
#
# @summary This class is meant to be called from kubeadm
# It sets variables according to platform
#
class kubeadm::params {

  $config_dir            = '/etc/kubeadm'
  $config_defaults       = { 'kind' => 'MasterConfiguration', 'apiVersion' => 'kubeadm.k8s.io/v1alpha1' }
  $config_hash           = {}
  $manage_repos          = true
  $master                = false
  $package_ensure        = 'latest'
  $package_name          = 'kubeadm'
  $pretty_config         = true
  $pretty_config_indent  = 4
  $purge_config_dir      = true
  $refresh_controlplane  = true


}
