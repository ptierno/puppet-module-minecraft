require 'spec_helper'

describe 'minecraft::ipban', :type => :define do
  let(:title) { 'fooplayer' }
  let(:facts) do { :concat_basedir => '/dne' } end
  let(:default_params) do {
  	:dir    => '/baz/qux',
  	:file   => 'banned-ips.txt',
  	:ensure => 'present',
  	:owner  => 'foo',
  	:group  => 'bar',
  	:mode   => '0644'
  } end
  context 'with ensure set to present' do
    let(:params) do default_params end
    it { should contain_minecraft__ipban('fooplayer') }
    it { should contain_concat('/baz/qux/banned-ips.txt').with({
      :owner => 'foo',
      :group => 'bar',
      :mode  => '0644',
      :force => 'true',
      :warn  => 'true'
    }) }
    it { should contain_concat__fragment('ipban_fragment_fooplayer').with({
      :ensure  => 'present',
      :target  => '/baz/qux/banned-ips.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
    it { should contain_file('/baz/qux/banned-ips.txt') }
  end
  context 'with ensure set to absent' do 
  	let(:params) do default_params.merge!({ :ensure => 'absent'}) end
  	it { should contain_minecraft__ipban('fooplayer') }
    it { should contain_concat('/baz/qux/banned-ips.txt').with({
      :owner => 'foo',
      :group => 'bar',
      :mode  => '0644',
      :force => 'true',
      :warn  => 'true'
    }) }
    it { should contain_concat__fragment('ipban_fragment_fooplayer').with({
      :ensure  => 'absent',
      :target  => '/baz/qux/banned-ips.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
    it { should contain_file('/baz/qux/banned-ips.txt') }
  end
end