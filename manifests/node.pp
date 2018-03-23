# == Class kubeadm::node
#
# @summary This manages and configures kubernetes nodes with kubeadm
#
class kubeadm::node {

  $notify_on_change = $kubeadm::manage_kubelet ? {
    true    => Service['kubelet'],
    default => undef,
  }

  # if the bootstrapped fact isn't set
  # join the cluster
  if ! $::kubeadm_bootstrapped {
    exec { 'kubeadm join':
      command => "kubeadm join --config ${kubeadm::config_dir}/config.json",
      path    => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
      notify  => $notify_on_change,
    }
  }
}


