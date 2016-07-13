require 'spec_helper'
describe 'scl' do
  context 'with default values for all parameters' do
    let(:facts){{:os => {
      :release => {
        :major => '6'
        }
      }
    }}


    it { should compile }
    it { should contain_class('scl::repos') }

    it do
      is_expected.to contain_file('scl-shebang').with({
        'ensure' => 'file',
        'owner' => 'root',
        'group' => '0',
        'mode' => '0755',
      })
    end
  end

  context 'with two ruby packages' do
    let(:facts){{:os => {
      :release => {
        :major => '6'
        }
      }
    }}

    let(:params) do
      {
        :os_maj_release => '6',
        :packages => [ 'rh-ruby22', 'ruby193' ],
        :gem_source => 'https://rubygems.org',
        :shebangs => [ 'rh-ruby22', 'ruby193' ],
      }
    end

    it do
      is_expected.to contain_package('rh-ruby22').with({
        'ensure' => 'present',
      })
    end

    it do
      is_expected.to contain_package('ruby193').with({
        'ensure' => 'present',
        })
    end
  end
end
