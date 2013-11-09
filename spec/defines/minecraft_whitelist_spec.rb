require 'spec_helper'

describe 'minecraft::whitelist', :type => :define do
  let(:title) { 'fooplayer' }
  let(:facts) do {
    :concat_basedir => '/dne',
    :osfamily => 'Debian',
    :lsbdistcodename => 'raring'
  } end
  let(:default_params) do {
  	:file   => 'white-list.txt',
  	:ensure => 'present'
  } end
  context 'with ensure set to present' do
    let(:params) do default_params end
    it { should contain_minecraft__whitelist('fooplayer') }
    it { should contain_concat__fragment('whitelist_fragment_fooplayer').with({
      :ensure  => 'present',
      :target  => '/opt/minecraft/white-list.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
  end
  context 'with ensure set to absent' do 
  	let(:params) do default_params.merge!({ :ensure => 'absent'}) end
  	it { should contain_minecraft__whitelist('fooplayer') }
    it { should contain_concat__fragment('whitelist_fragment_fooplayer').with({
      :ensure  => 'absent',
      :target  => '/opt/minecraft/white-list.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
  end
end