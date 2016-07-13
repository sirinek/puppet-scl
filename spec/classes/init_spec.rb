require 'spec_helper'
describe 'scl' do
  context 'with default values for all parameters' do
    let(:facts){{:os => {
      :release => {
        :major => '6'
        }
      }
    }}


    it { is_expected.to compile }
    it { is_expected.to contain_class('scl') }
    it { is_expected.to contain_class('scl::repos') }
    it { is_expected.to contain_class('scl::params') }
    it { is_expected.to contain_exec('import-scl-gpg-key') }


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

    it { is_expected.to contain_scl__package('rh-ruby22') }
    it { is_expected.to contain_scl__package('ruby193') }
    it { is_expected.to contain_scl__shebang('rh-ruby22') }
    it { is_expected.to contain_scl__shebang('ruby193') }

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

    it { is_expected.to contain_file('scl-shebang-rh-ruby22') }
    it { is_expected.to contain_file('scl-shebang-ruby193') }
  end
end
