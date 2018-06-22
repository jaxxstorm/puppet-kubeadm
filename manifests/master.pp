# == Class kubeadm::master
#
# @summary This manages and configures kubernetes masters with kubeadm
#
class kubeadm::master (
  $refresh_controlplane,
){

  exec{'kubeadm init':
    command => "kubeadm init --config ${::kubeadm::config_dir}/config.json",
    path    => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
    creates => '/etc/kubernetes/kubelet.conf',
  }

  file{'/etc/kubernetes/manifests/kube-apiserver.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec['kubeadm init'],
  }
  file{'/etc/kubernetes/manifests/kube-controller-manager.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec['kubeadm init'],
  }
  file{'/etc/kubernetes/manifests/kube-scheduler.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec['kubeadm init'],
  }

}


