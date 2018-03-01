# === Class kubeadm::install
#
# Installs kubeadm based on parameters passed
#
class kubeadm::install {

  package { $kubeadm::package_name:
    ensure => $kubeadm::package_ensure,
  }

}
