# == Class kubeadm::node
#
# @summary This manages and configures kubernetes nodes with kubeadm
#
class kubeadm::node(
  Optional[Array] $ignore_preflight_errors,
){
  # if the bootstrapped fact isn't set
  # join the cluster
  $flags = kubeadm_flags({
    config                  => "${::kubeadm::config_dir}/config.json",
    ignore_preflight_errors => $ignore_preflight_errors,
  })
  if ! $::kubeadm_bootstrapped {
    exec { 'kubeadm join':
      command => "kubeadm join ${flags}",
      path    => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
      creates => '/etc/kubernetes/kubelet.conf',
    }
  }
}


