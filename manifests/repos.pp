# == Class kubeadm::repos
#
# @summary This installs the public kubernetes repos
#
class kubeadm::repos (
  $manage_repos
){

  if $manage_repos {
    case $::osfamily {
      'RedHat': {
        yumrepo { 'kubernetes':
          descr   => 'kubernetes-public-repo',
          baseurl => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
          gpgkey  => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
        }
      }
      'Debian': {
        apt::source { 'kubernetes':
          location => 'http://apt.kubernetes.io',
          repos    => 'main',
          release  => 'kubernetes-xenial',
          key      => {
            'id'     => 'D0BC747FD8CAF7117500D6FA3746C208A7317B0F',
            'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
          },
        }
      }
      default: { notify {"The OS family ${::os_family} is not supported by this module":} }
    }
  }


}
