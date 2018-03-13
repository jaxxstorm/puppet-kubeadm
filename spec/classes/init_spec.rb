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
    }
  end

  context 'with default values for all parameters' do
    it { should_not compile } # by default, we need to specify a bootstrap master
  end

  context 'should install kubeadm' do
    let(:params) {{ 'bootstrap_master' => 'host' }}
    it { should contain_package('kubeadm').with(:ensure => 'latest') }
  end

  context 'should manage config' do
    let(:params) {{ 'bootstrap_master' => 'host' }}
    it { should contain_file('/etc/kubeadm').with(:ensure => 'directory') }
    it { should contain_file('kubeadm config.json').with(:ensure => 'present', :path => '/etc/kubeadm/config.json').that_requires('File[/etc/kubeadm]') }
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


end
