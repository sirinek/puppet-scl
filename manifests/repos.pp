#
# Manage the repos necessary for SCL this class should enable a user to
# declare the baseurl explicitly for scl repositories rather than rely
# only on the packages' configs
#
# example
# -------
#
# class { 'scl::repos':
#  repo_url_sclo => 'http://mirror.urmom/centos/6/sclo/\$basearch/sclo/"
#  repo_url_rh   => 'http://mirror.urmom/centos/6/sclo/\$basearch/rh/"
# }
#
class scl::repos (
  Boolean $repo_enabled_sclo = $scl::repo_enabled_sclo,
  String $repo_present_sclo  = $scl::repo_present_sclo,
  String $repo_url_sclo      = $scl::repo_url_sclo,
  Boolean $repo_enabled_rh   = $scl::repo_enabled_rh,
  String $repo_present_rh    = $scl::repo_present_rh,
  String $repo_url_rh        = $scl::repo_url_rh,
  String $repo_gpg_key       = $scl::repo_gpg_key,
  String $os_maj_release     = $scl::os_maj_release
) {

  yumrepo { 'CentOS-SCLo-scl':
    ensure   => $repo_present_sclo,
    descr    => 'CentOS Software Collections',
    baseurl  => $repo_url_sclo,
    enabled  => $repo_enabled_sclo,
    gpgcheck => true,
    gpgkey   => $repo_gpg_key,
  }

  yumrepo { 'CentOS-SCLo-scl-rh':
    ensure   => $repo_present_rh,
    descr    => "CentOS-${os_maj_release} - SCLo rh",
    baseurl  => $repo_url_rh,
    enabled  => $repo_enabled_rh,
    gpgcheck => true,
    gpgkey   => $repo_gpg_key,
  }

  # Storing the scl gpg key in this module
  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/scl/RPM-GPG-KEY-CentOS-SIG-SCLo',
    notify => Exec['import-scl-gpg-key'],
  }
  # Manage the gpg key via the file
  # in this module
  exec { 'import-scl-gpg-key':
    path      => '/bin:/usr/bin',
    command   => "rpm --import ${repo_gpg_key}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids --keyid-format short < ${repo_gpg_key}) | cut --characters=11-19 | tr '[A-Z]' '[a-z]')",
    logoutput => 'on_failure',
    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo'],
    before    => Yumrepo['CentOS-SCLo-scl', 'CentOS-SCLo-scl-rh'],
  }
}
