require 'spec_helper'

describe 'minecraft::ipban', :type => :define do
  let(:title) { 'fooplayer' }
  let(:facts) do {
    :concat_basedir => '/dne',
    :osfamily => 'Debian',
    :lsbdistcodename => 'raring'
  } end
  let(:default_params) do {
  	:file   => 'banned-ips.txt',
  	:ensure => 'present'
  } end
  context 'with ensure set to present' do
    let(:params) do default_params end
    it { should contain_minecraft__ipban('fooplayer') }
    it { should contain_concat__fragment('ipban_fragment_fooplayer').with({
      :ensure  => 'present',
      :target  => '/opt/minecraft/banned-ips.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
  end
  context 'with ensure set to absent' do 
  	let(:params) do default_params.merge!({ :ensure => 'absent'}) end
  	it { should contain_minecraft__ipban('fooplayer') }
    it { should contain_concat__fragment('ipban_fragment_fooplayer').with({
      :ensure  => 'absent',
      :target  => '/opt/minecraft/banned-ips.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
  end
end