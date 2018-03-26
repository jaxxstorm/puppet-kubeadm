require 'spec_helper'

describe 'kubectl', :type => :fact do

  before :each do
    Facter.clear
    Facter.clear_messages
  end

  expected = File.read('spec/expected/kubectl_client_server.json')

  context 'kubectl installed' do
      Facter::Core::Execution.stubs(:which).with('kubectl').returns nil
      it 'should return nil' do
        expect(Facter.fact(:has_kubectl).value).to eq nil
      end
  end

    
  context 'server and client returns' do
    it do
      Facter::Core::Execution.stubs(:execute).with('/usr/bin/kubectl version -o json').returns expected
        #expect(Facter.fact(:kubernetes_version).value).to be_a(Hash)
        expect(Facter.fact(:kubernetes_version).value).to include(
          'client' => "v1.8.4",
          'server' => "v1.8.4"
        )
    end
  end
end
