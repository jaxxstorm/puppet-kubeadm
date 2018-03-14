# == Class kubeadm::master
#
# @summary This manages and configures kubernetes masters with kubeadm
#
class kubeadm::master (
  $bootstrap_master,
  $master,
  $refresh_controlplane,
){

  $subscribe = $refresh_controlplane ? {
    true    => File['kubeadm config.json'],
    default => undef,
  }

  if $master {
    # if we are a master, install the components we need to update the controlplane
    # every time the config file changes
    exec { 'kubeadm controlplane':
      command     => "kubeadm alpha phase controlplane all --config ${kubeadm::config_dir}/config.json && sleep 10", # this is to ensure the controlplane returns
      path        => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
      subscribe   => $subscribe,
      require     => Package['kubeadm'],
      refreshonly => $refresh_controlplane,
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


