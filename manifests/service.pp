# === Class kubeadm::service
#
# Manage the service for the kubelet
#
class kubeadm::service {

  if $kubeadm::manage_kubelet {
    service { $kubeadm::kubelet_service_name:
      ensure => $kubeadm::kubelet_service_ensure,
      enable => $kubeadm::kubelet_service_enable,
    }
  }


}
