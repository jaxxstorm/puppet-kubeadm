# Kubadmin facts
#
Facter.add(:kubeadm_bootstrapped) do

  setcode do
     File.exist? '/etc/kubernetes/kubelet.conf'
  end
end
