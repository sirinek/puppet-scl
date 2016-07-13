require 'spec_helper'

describe 'scl::gems' do
  let(:title){'rh-ruby22-gems'}
  let(:params) do
    {
      :scl_ruby_version => 'rh-ruby22',
      :scl_gems => {
        'json' => {
          'ensure' => '1.8.1',
        },
        'daemons' => {}
      },
    }
  end

  it do
    is_expected.to contain_package('json-rh-ruby22').with({
      'ensure' => '1.8.1',
      'name' => 'json',
      'provider' => 'rh_ruby22_gem',
      'source' => 'https://rubygems.org',
      'install_options' => [ '--no-rdoc', '--no-ri'],
    })
  end

  it do
    is_expected.to contain_package('daemons-rh-ruby22').with({
      'ensure' => 'present',
      'name' => 'daemons',
      'provider' => 'rh_ruby22_gem',
      'source' => 'https://rubygems.org',
      'install_options' => [ '--no-rdoc', '--no-ri'],
    })
  end
end
