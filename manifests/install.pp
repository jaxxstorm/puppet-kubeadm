# === Class kubeadm::install
#
# Installs kubeadm based on parameters passed
#
class kubeadm::install {

  package {$::kubeadm::package_name:
    ensure => $kubeadm::package_ensure,
  }

  if $::kubeadm::manage_kubelet {
    package { $kubeadm::kubelet_package_name:
      ensure => $::kubeadm::kubelet_package_ensure,
    }
  }

  if $kubeadm::manage_kubectl {
    package {$::kubeadm::kubectl_package_name:
      ensure => $kubeadm::kubectl_package_ensure,
    }
  }

}
