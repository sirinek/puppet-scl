# Class: scl
# ===========================
#
# Full description of class scl here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'scl':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Jacob Castello <jacob@arin.net>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class scl (
  Boolean $manage_repos = true,
  Boolean $repo_enabled_sclo = $scl::params::repo_enabled_sclo,
  String $repo_present_sclo = $scl::params::repo_present_sclo,
  String $repo_url_sclo = $scl::params::repo_url_sclo,
  Boolean $repo_enabled_rh = $scl::params::repo_enabled_rh,
  String $repo_present_rh = $scl::params::repo_present_rh,
  String $repo_url_rh = $scl::params::repo_url_rh,
  String $repo_gpg_key = $scl::params::repo_gpg_key,
  String $os_maj_release = $scl::params::os_maj_release,
  Array $scl_packages = [],
  Array $scl_shebangs = $scl_packages
) inherits scl::params {

  if $manage_repos == true {
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

    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/scl/RPM-GPG-KEY-CentOS-SIG-SCLo',
      notify => Exec['import-scl-gpg-key'],
    }

    # This shebang line is
    # the over-arching 'enable'
    # needed for all other 
    # package shebangs
    file { 'scl-shebang':
      ensure  => file,
      path    => '/usr/local/bin/scl-shebang',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('scl/scl-shebang.erb'),
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

  scl::shebang { $scl_shebangs: }
}
