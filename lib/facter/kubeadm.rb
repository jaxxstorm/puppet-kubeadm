# Kubadmin facts
#
Facter.add(:kubeadm_bootstrapped) do

  setcode do
    bootstrapped = File.exist? '/etc/kubernetes/kubelet.conf'
  end

  return bootstrapped



end
