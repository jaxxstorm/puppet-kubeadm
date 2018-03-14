require 'spec_helper'
require 'facter/kubeadm'

describe Facter::Util::Fact do

  before {
    Facter.clear
  }

  describe 'kubeadm', :type => :fact do
    
    context 'file exists, should return true' do
      it do
        File.stubs(:exist?).with('/etc/kubernetes/kubelet.conf').returns(true)
        expect(Facter.fact(:kubeadm_bootstrapped).value).to match(true)
      end
    end

    context 'file not exist, should return false' do
      it do
        File.stubs(:exist?).with('/etc/kubernetes/kubelet.conf').returns(false)
        expect(Facter.fact(:kubeadm_bootstrapped).value).to match(false)
      end

    end

  end

end
