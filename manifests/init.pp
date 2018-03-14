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
# @param manage_repos Whether to install and manage the public kubernetes repos
#
# @param master Whether to install the master components, or run kubeadm join
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
  $bootstrap_master                          = undef, # required parameter
  $config_dir                                = $kubeadm::params::config_dir,
  Hash $config_defaults                      = $kubeadm::params::config_defaults,
  Hash $config_hash                          = $kubeadm::params::config_hash,
  Boolean $manage_repos                      = $kubeadm::params::manage_repos,
  Boolean $master                            = $kubeadm::params::master,
  $package_ensure                            = $kubeadm::params::package_ensure,
  $package_name                              = $kubeadm::params::package_name,
  Boolean $pretty_config                     = $kubeadm::params::pretty_config,
  Integer $pretty_config_indent              = $kubeadm::params::pretty_config_indent,
  Boolean $purge_config_dir                  = $kubeadm::params::purge_config_dir,
) inherits kubeadm::params {


  if !$bootstrap_master {
    fail('kubeadm::init: Must specify a bootstrap master - it should be set to a hostname of a single cluster master')
  }

  $config_hash_real = deep_merge($config_defaults, $config_hash)


  anchor { 'kubeadm_first': }
  -> class { 'kubeadm::repos':
    manage_repos => $manage_repos,
  }
  -> class { 'kubeadm::install': }
  -> class { 'kubeadm::configure':
    config_hash => $config_hash_real,
    purge       => $purge_config_dir,
  }
  -> class { 'kubeadm::master':
    master           => $master,
    bootstrap_master => $bootstrap_master,
  }
  -> anchor { 'kubeadm_last': }

}
