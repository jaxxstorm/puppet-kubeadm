# kubeadm

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with kubeadm](#setup)
    * [What kubeadm affects](#what-kubeadm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kubeadm](#beginning-with-kubeadm)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

puppet-kubeadm installs and manages kubeadm for you.

It allows you to generate kubeadm configuration, and then manage and run kubeadm as needed.

## Setup

### What kubeadm affects

This module will:

  * Optionally install the kubeadm package repos
  * Install the kubadm package
  * Generate a [kubeadm configuration](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#config-file) from a Puppet hash object
  * Execute and run kubeadm depending on the status of your system

### Beginning with kubeadm

Because kubeadm's init command isn't idempotent, we need to specify a single master to run the init command. To get started, do this:

```
class { '::kubeadm':
  bootstrap_master => 'kube-master-1',
}
```

Will get you going

## Usage

Coming Soon

## Reference

Coming Soon

## Limitations

Coming Soon

## Development

Coming Soon
