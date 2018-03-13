class kubeadm::kubeadm_init {


  exec { 'kubeadm init':
    command => "kubeadm init --config $kubeadm::config_dir/config.json",
    path    => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin',
    require => [ Package['kubeadm'] ],
    creates => '/etc/kubernetes/admin.conf',
  }

}
