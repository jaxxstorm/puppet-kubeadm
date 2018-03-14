# == Class kubeadm::master
#
# @summary This manages and configures kubernetes masters with kubeadm
#
class kubeadm::master (
  $master,
  $bootstrap_master,
){

  if $master {
    # if we are a master, install the components we need to update the controlplane
    # every time the config file changes
    exec { 'kubeadm controlplane':
      command     => "kubeadm alpha phase controlplane all --config ${kubeadm::config_dir}/config.json",
      path        => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
      subscribe   => File['kubeadm config.json'],
      require     => Package['kubeadm'],
      refreshonly => true,
    }
    -> exec { 'kubeadm kubeconfig':
      command => "kubeadm alpha phase kubeconfig --config ${kubeadm::config_dir}/config.json",
      path    => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
      require => Package['kubeadm'],
      creates => [ '/etc/kubernetes/admin.conf', '/etc/kubernetes/kubelet.conf' ],
    }

    file { '/etc/kubernetes/manifests/kube-apiserver.yaml':
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Exec['kubeadm controlplane'],
    }
    file { '/etc/kubernetes/manifests/kube-controller-manager.yaml':
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Exec['kubeadm controlplane'],
    }
    file { '/etc/kubernetes/manifests/kube-scheduler.yaml':
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Exec['kubeadm controlplane'],
    }

  }
}


