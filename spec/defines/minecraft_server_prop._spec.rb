require 'spec_helper'

describe 'minecraft::server_prop', :type => :define do
  let(:title) { 'foo_key' }
  let(:facts) do {
    :concat_basedir  => '/dne',
    :osfamily        => 'Debian',
    :lsbdistcodename => 'raring'
  } end
  let(:default_params) do {
    :file   => 'server.properties',
    :ensure => 'present',
    :value  => 'foo_value'
  } end
  context 'with ensure set to present' do
    let(:params) do default_params end
    it { should contain_minecraft__server_prop('foo_key').with({ :value => 'foo_value' }) }
    it { should contain_concat__fragment('server_prop_fragment_foo_key').with({
      :ensure  => 'present',
      :target  => '/opt/minecraft/server.properties',
      :content => 'foo_key=foo_value',
      :notify  => 'Service[minecraft]'
    }) }
  end
  context 'with ensure set to absent' do 
    let(:params) do default_params.merge!({ :ensure => 'absent'}) end
    it { should contain_minecraft__server_prop('foo_key') }
    it { should contain_concat__fragment('server_prop_fragment_foo_key').with({
      :ensure  => 'absent',
      :target  => '/opt/minecraft/server.properties',
      :content => 'foo_key=foo_value',
      :notify  => 'Service[minecraft]'
    }) }
  end
end