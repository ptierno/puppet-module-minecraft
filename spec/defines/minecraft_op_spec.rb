

require 'spec_helper'

describe 'minecraft::op', :type => :define do
  let(:title) { 'fooplayer' }
  let(:facts) do {
    :concat_basedir => '/dne',
    :osfamily => 'Debian',
    :lsbdistcodename => 'raring'
  } end
  let(:default_params) do {
  	:dir    => '/baz/qux',
  	:file   => 'ops.txt',
  	:ensure => 'present'
  } end
  context 'with ensure set to present' do
    let(:params) do default_params end
    it { should contain_minecraft__op('fooplayer') }
    it { should contain_concat__fragment('op_fragment_fooplayer').with({
      :ensure  => 'present',
      :target  => '/baz/qux/ops.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
  end
  context 'with ensure set to absent' do 
  	let(:params) do default_params.merge!({ :ensure => 'absent'}) end
  	it { should contain_minecraft__op('fooplayer') }
    it { should contain_concat__fragment('op_fragment_fooplayer').with({
      :ensure  => 'absent',
      :target  => '/baz/qux/ops.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
  end
end