# == Class kubeadm::master
#
# @summary This manages and configures kubernetes masters with kubeadm
#
class kubeadm::master (
  Boolean $refresh_controlplane,
  Optional[Array] $ignore_preflight_errors,
){

  $subscribe = ($::kubeadm_bootstrapped and $refresh_controlplane )? {
    true    => File['kubeadm config.json'],
    default => undef,
  }

  # if we are a master, install the components we need to update the controlplane
  # every time the config file changes
  $controlplane_cmd = "kubeadm alpha phase controlplane all --config ${::kubeadm::config_dir}/config.json && sleep 10"
  exec { 'kubeadm controlplane':
    command     => $controlplane_cmd,
    path        => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
    subscribe   => $subscribe,
    refreshonly => true,
  }
  ~> exec { 'kubeadm kubeconfig':
    command     => "kubeadm alpha phase kubeconfig all --config ${kubeadm::config_dir}/config.json",
    path        => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
    refreshonly => true,
  }

  $flags = kubeadm_flags({
    config                  => "${::kubeadm::config_dir}/config.json",
    ignore_preflight_errors => $ignore_preflight_errors,
  })

  exec{'kubeadm init':
    command => "kubeadm init ${flags}",
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


