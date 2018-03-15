require 'spec_helper'
describe 'kubeadm' do


  RSpec.configure do |c|
    c.default_facts = {
      :architecture           => 'x86_64',
      :operatingsystem        => 'CentOS',
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '7.1.1503',
      :kernel                 => 'Linux',
      :fqdn                   => 'test',
      :ipaddress              => '192.168.5.10',
      :kubeadm_bootstrapped   => false,
    }
  end

  context 'with default values for all parameters' do
    it { should_not compile } # by default, we need to specify a bootstrap master
  end

  context 'should install packages' do
    let(:params) {{ 'bootstrap_master' => 'host' }}
    it { should contain_package('kubeadm').with(:ensure => 'latest') }
    it { should contain_package('kubectl').with(:ensure => 'latest') }
    it { should contain_package('kubelet').with(:ensure => 'latest') }
  end

  context 'should contain service' do
    let(:params) {{ 'bootstrap_master' => 'host' }}
    it { should contain_service('kubelet').with(:ensure => true, :enable => true ) }
  end

  context 'manage service param' do
    let(:params) {{ 'bootstrap_master' => 'host', 'manage_kubelet' => false, 'manage_kubectl' => false, }}
    it { should_not contain_service('kubelet') }
    it { should_not contain_package('kubelet') }
    it { should_not contain_package('kubectl') }
    it { should contain_file('kubeadm config.json').with(:ensure => 'present', :path => '/etc/kubeadm/config.json', :notify => nil).that_requires('File[/etc/kubeadm]') }
  end

  context 'should manage config' do
    let(:params) {{ 'bootstrap_master' => 'host' }}
    it { should contain_file('/etc/kubeadm').with(:ensure => 'directory') }
    it { should contain_file('kubeadm config.json').with(:ensure => 'present', :path => '/etc/kubeadm/config.json', :notify => 'Service[kubelet]').that_requires('File[/etc/kubeadm]') }
  end
  
  context 'custom config dir' do
    let(:params) {{ 'config_dir' => '/opt/kubeadm', 'bootstrap_master' => 'host' }}
    it { should contain_file('/opt/kubeadm').with(:ensure => 'directory') }
    it { should contain_file('kubeadm config.json').with(:ensure => 'present', :path => '/opt/kubeadm/config.json').that_requires('File[/opt/kubeadm]') }
  end

  context 'install yum repos' do
    let(:params) {{ 'bootstrap_master' => 'host' }}
    it { should contain_yumrepo('kubernetes') }
  end

  context 'dont manage repos' do
    let(:params) {{ 'manage_repos' => false, 'bootstrap_master' => 'host' }}
    it { should_not contain_yumrepo('kubernetes') }
  end

  context 'master configuration' do
    let(:facts)  {{ 'kubeadm_bootstrapped' => true }}
    let(:params) {{ 'master' => true, 'bootstrap_master' =>'test', 'refresh_controlplane' => true }}
    it { should contain_exec('kubeadm controlplane').with(:command => 'kubeadm alpha phase controlplane all --config /etc/kubeadm/config.json && sleep 10', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin', :subscribe => 'File[kubeadm config.json]', :refreshonly => true) }
    it { should contain_exec('kubeadm kubeconfig').with(:command => 'kubeadm alpha phase kubeconfig --config /etc/kubeadm/config.json', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin', :creates => [ '/etc/kubernetes/admin.conf', '/etc/kubernetes/kubelet.conf' ]) }
  end

  context 'master config, don\'t refresh' do
    let(:facts)  {{ 'kubeadm_bootstrapped' => true, 'fqdn' => 'master-1' }}
    let(:params) {{ 'master' => true, 'bootstrap_master' =>'master-1', 'refresh_controlplane' => false }}
    it { should contain_exec('kubeadm controlplane').with(:command => 'kubeadm alpha phase controlplane all --config /etc/kubeadm/config.json && sleep 10', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin', :refreshonly => false) }
    it { should contain_exec('kubeadm kubeconfig').with(:command => 'kubeadm alpha phase kubeconfig --config /etc/kubeadm/config.json', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin', :creates => [ '/etc/kubernetes/admin.conf', '/etc/kubernetes/kubelet.conf' ]) }
    it { should_not contain_exec('kubeadm init') }
  end

  context 'node configuration' do
    let(:facts) {{ 'kubeadm_bootstrapped' => false }}
    let(:params) {{ 'master' => false, 'bootstrap_master' => 'test' }}
    it { should contain_exec('kubeadm join').with(:command => 'kubeadm join --config /etc/kubeadm/config.json', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin') }
  end

  context 'node already bootstrapped' do 
    let(:facts) {{ 'kubeadm_bootstrapped' => true }}
    let(:params) {{ 'master' => false, 'bootstrap_master' => 'test' }}
    it { should_not contain_exec('kubeadm join').with(:command => 'kubeadm join --config /etc/kubeadm/config.json', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin') }
  end

  context 'when not bootstrapped, and we\'re the bootstrap master' do
    let(:facts) {{ 'kubeadm_bootstrapped' => false, 'fqdn' => 'master-1' }}
    let(:params) {{ 'master' => true, 'bootstrap_master' =>'master-1' }}
    it { should contain_exec('kubeadm init').with(:command => 'kubeadm init --config /etc/kubeadm/config.json && touch /etc/kubeadm/.bootstrapped', :path => '/usr/bin:/usr/local/bin:/usr/sbin:/sbin', :creates => '/etc/kubeadm/.bootstrapped') }

  end

end
