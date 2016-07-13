require 'spec_helper'

describe 'scl::repos' do
  context 'with default values for all parameters' do
    let(:params) do
      {
        :repo_enabled_sclo => true,
        :repo_present_sclo => 'present',
        :repo_url_sclo => 'http://mirror.centos.org/centos/6/sclo/\$basearch/sclo/',
        :repo_enabled_rh => true,
        :repo_present_rh => 'present',
        :repo_url_rh => 'http://mirror.centos.org/centos/6/sclo/\$basearch/rh/',
        :repo_gpg_key => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',
        :os_maj_release => '6'
      }
    end

    it do
      is_expected.to contain_yumrepo('CentOS-SCLo-scl').with({
        'ensure' => 'present',
        'descr' => 'CentOS Software Collections',
        'baseurl' => 'http://mirror.centos.org/centos/6/sclo/\$basearch/sclo/',
        'enabled' => true,
        'gpgcheck' => true,
        'gpgkey' => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',
      })
    end

    it do
      is_expected.to contain_yumrepo('CentOS-SCLo-scl-rh').with({
        'ensure' => 'present',
        'descr' => 'CentOS-6 - SCLo rh',
        'baseurl' => 'http://mirror.centos.org/centos/6/sclo/\$basearch/rh/',
        'enabled' => true,
        'gpgcheck' => true,
        'gpgkey' => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',
      })
    end

    it { is_expected.to contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo')}

  end
end
