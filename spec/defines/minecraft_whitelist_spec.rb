require 'spec_helper'

describe 'minecraft::whitelist', :type => :define do
  let(:title) { 'fooplayer' }
  let(:facts) do { :concat_basedir => '/dne' } end
  let(:default_params) do {
  	:dir    => '/baz/qux',
  	:file   => 'white-list.txt',
  	:ensure => 'present',
  	:owner  => 'foo',
  	:group  => 'bar',
  	:mode   => '0644'
  } end
  context 'with ensure set to present' do
    let(:params) do default_params end
    it { should contain_minecraft__whitelist('fooplayer') }
    it { should contain_concat('/baz/qux/white-list.txt').with({
      :owner => 'foo',
      :group => 'bar',
      :mode  => '0644',
      :force => 'true',
      :warn  => 'true'
    }) }
    it { should contain_concat__fragment('whitelist_fragment_fooplayer').with({
      :ensure  => 'present',
      :target  => '/baz/qux/white-list.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
    it { should contain_file('/baz/qux/white-list.txt') }
  end
  context 'with ensure set to absent' do 
  	let(:params) do default_params.merge!({ :ensure => 'absent'}) end
  	it { should contain_minecraft__whitelist('fooplayer') }
    it { should contain_concat('/baz/qux/white-list.txt').with({
      :owner => 'foo',
      :group => 'bar',
      :mode  => '0644',
      :force => 'true',
      :warn  => 'true'
    }) }
    it { should contain_concat__fragment('whitelist_fragment_fooplayer').with({
      :ensure  => 'absent',
      :target  => '/baz/qux/white-list.txt',
      :content => 'fooplayer',
      :notify  => 'Service[minecraft]'
    }) }
    it { should contain_file('/baz/qux/white-list.txt') }
  end
end