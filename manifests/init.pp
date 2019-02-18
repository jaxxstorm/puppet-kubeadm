# Class: kubeadm
# ===========================
#
# @summary Init class for installing, managing and configuring kubeadm
#
# Parameters
# ----------
#
# @param config_dir Directory to place kubeadm configuration files in.
#
# @param config_defaults Configuration defaults hash. Gets merged with config_hash.
#
# @param config_hash Use this to populate the JSON config file for kubeadm.
#
# @param kubectl_package_ensure The version of kubectl to install.
#
# @param kubelet_package_ensure The version of kubelet to install.
#
# @param kubectl_package_name The name of the kubectl package to install.
#
# @param kubelet_package_name The name of the kubelet package to install.
#
# @param kubelet_service_enable The enable status of the kubelet service. Defaults to `true`.
#
# @param kubelet_service_ensure The status of the managed kubelet service. Defaults to `true`.
#
# @param kubelet_service_name The name of the kubelet service.
#
# @param manage_kubectl Whether to install the kubectl package.
#
# @param manage_kubectl Whether to install and manage the kubelet package and service.
#
# @param manage_repos Whether to install and manage the public kubernetes repos.
#
# @param master Whether to install the master components, or run kubeadm join.
#
# @param package_ensure Only valid when the install_method == package. Defaults to `latest`.
#
# @param package_name Only valid when the install_method == package. Defaults to `kubeadm`.
#
# @param pretty_config Generates a human readable JSON config file. Defaults to `true`.
#
# @param pretty_config_indent Toggle indentation for human readable JSON file. Defaults to `4`.
#
# @param purge_config_dir Purge config files no longer generated by Puppet
#
# @param refresh_controlplane Refresh controlplane when the kubeadm configuration file changes. Defaults to `true`.
#
# Authors
# -------
#
# Lee Briggs <lbriggs@apptio.com>
#
# Copyright
# ---------
#
# Copyright 2018 Lee Briggs, unless otherwise noted.
#
class kubeadm (
  $config_dir                              = $kubeadm::params::config_dir,
  Hash $config_defaults                    = $kubeadm::params::config_defaults,
  Hash $config_hash                        = $kubeadm::params::config_hash,
  $kubectl_package_name                    = $kubeadm::params::kubectl_package_name,
  $kubelet_package_name                    = $kubeadm::params::kubelet_package_name,
  $kubectl_package_ensure                  = $kubeadm::params::kubectl_package_ensure,
  $kubelet_package_ensure                  = $kubeadm::params::kubelet_package_ensure,
  Boolean $kubelet_service_enable          = $kubeadm::params::kubelet_service_enable,
  $kubelet_service_ensure                  = $kubeadm::params::kubelet_service_ensure,
  $kubelet_service_name                    = $kubeadm::params::kubelet_service_name,
  Boolean $manage_kubectl                  = $kubeadm::params::manage_kubectl,
  Boolean $manage_kubelet                  = $kubeadm::params::manage_kubelet,
  Boolean $manage_repos                    = $kubeadm::params::manage_repos,
  Boolean $master                          = $kubeadm::params::master,
  $package_ensure                          = $kubeadm::params::package_ensure,
  $package_name                            = $kubeadm::params::package_name,
  Boolean $pretty_config                   = $kubeadm::params::pretty_config,
  Integer $pretty_config_indent            = $kubeadm::params::pretty_config_indent,
  Boolean $purge_config_dir                = $kubeadm::params::purge_config_dir,
  Boolean $replace_kubadm_config           = $kubeadm::params::replace_kubadm_config,
  Boolean $refresh_controlplane            = $kubeadm::params::refresh_controlplane,
  Optional[Array] $ignore_preflight_errors = []
) inherits kubeadm::params {

  $config_hash_real = deep_merge($config_defaults, $config_hash)


  class {'::kubeadm::repos':
    manage_repos => $manage_repos
  }
  -> class {'::kubeadm::install': }
  -> class {'::kubeadm::configure':
    config_hash => $config_hash_real,
    purge       => $purge_config_dir,
    replace     => $replace_kubadm_config,
  }
  -> class {'::kubeadm::service': }

  if $master {
    Class['::kubeadm::service']
    -> class {'::kubeadm::master':
      ignore_preflight_errors => $ignore_preflight_errors,
      refresh_controlplane    => $refresh_controlplane,
    }
    contain ::kubeadm::master
  }

  unless $master{
    class{'::kubeadm::node':
      ignore_preflight_errors => $ignore_preflight_errors,
    }
    contain ::kubeadm::node
    Class['kubeadm::service']
    -> Class['kubeadm::node']
  }

  contain ::kubeadm::repos
  contain ::kubeadm::install
  contain ::kubeadm::configure
  contain ::kubeadm::service

}
