# Kubeadm facts
require 'json'

Facter.add(:has_kubeadm) do
  confine :kernel => :linux
  setcode do
    Facter::Util::Resolution.which('kubeadm') ? true : false
  end
end


Facter.add(:kubeadm_version) do
  confine :kernel => :linux
  confine :has_kubeadm => true

  kubeadm_json = Facter::Core::Execution.execute('/usr/bin/kubeadm version -o json')
  kubeadm_parsed_json = JSON.parse(kubeadm_json)

  setcode do
    kubeadm_parsed_json['clientVersion']['gitVersion'],
  end

end

Facter.add(:kubeadm_bootstrapped) do
  setcode do
     File.exist? '/etc/kubernetes/kubelet.conf'
  end
end
