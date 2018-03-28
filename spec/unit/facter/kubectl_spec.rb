require 'spec_helper'

describe 'kubectl fact' do

  before :each do
    Facter.clear
  end

  context 'when on Linux' do
    before :each do
      Facter.fact(:kernel).expects(:value).at_least(1).returns('Linux')
    end

    context 'has_kubectl fact' do
      it 'kubectl not present' do
        # all other calls
        Facter::Util::Resolution.stubs('exec')
        Facter::Util::Resolution.expects('which').with('kubectl').at_least(1).returns(false)
        expect(Facter.value(:has_kubectl)).to be_falsey
      end

      it 'kubectl installed' do
        # all other calls
        Facter::Util::Resolution.stubs('exec')
        Facter::Util::Resolution.expects('which').with('kubectl').at_least(1).returns('/usr/bin/kubectl')
        expect(Facter.value(:has_kubectl)).to be_truthy
      end
    end


  end
end
