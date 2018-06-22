# === Class kubeadm::service
#
# Manage the service for the kubelet
#
class kubeadm::service {

  # if we're not bootstrapped, don't enable the kubelet service
  # kubeadm will usually do the initial enable for us
  $service_ensure_real = $::kubeadm_bootstrapped ? {
    true    => $kubeadm::kubelet_service_ensure,
    default => 'stopped',
  }

  if $kubeadm::manage_kubelet {
    service { $kubeadm::kubelet_service_name:
      ensure => $service_ensure_real,
      enable => $kubeadm::kubelet_service_enable,
    }
  }

}
