require 'spec_helper'

describe 'minecraft', :type => :class do
  let(:facts) do { 
    :osfamily        => 'Debian',
    :lsbdistcodename => 'raring',
    :concat_basedir  => '/dne' 
  } end
  let(:default_params) do {
    :user          => 'foo',
    :group         => 'bar',
    :homedir       => '/baz/qux',
    :manage_java   => true,
    :manage_screen => true,
    :manage_curl   => true,
    :heap_size     => '2048',
    :heap_start    => '512'
  } end
  context 'by default' do
    let(:params) do default_params end
    it { should include_class('minecraft') }
    it { should contain_class('java').with({
      :distribution => 'jre',
      :before       => 'Service[minecraft]'
    }) }
    it { should contain_package('screen').with({
      :before => 'Service[minecraft]'
    }) }
    it { should contain_package('curl').with({
      :before => 'S3file[/baz/qux/minecraft_server.jar]'
    }) }
    it { should contain_user('foo').with({
      :gid        => 'bar',
      :home       => '/baz/qux',
      :managehome => true,
    }) }
    it { should contain_group('bar').with({
      :ensure => 'present'
    }) }
    it { should contain_s3file('/baz/qux/minecraft_server.jar').with({
      :source  => 'MinecraftDownload/launcher/minecraft_server.jar',
      :require => 'User[foo]'
    }) }
    ['/baz/qux/banned-players.txt','/baz/qux/banned-ips.txt',
     '/baz/qux/white-list.txt','/baz/qux/ops.txt'].each do |file|
      it { should contain_file(file) }
    end
    it { should contain_file('/etc/init.d/minecraft').with({
      :ensure  => 'present',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0744'
    }).with_content(/MAX_HEAP="2048"\nMIN_HEAP="512"/) }
  end
end