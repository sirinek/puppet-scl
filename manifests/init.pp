# Class: scl
# ===========================
#
# Full description of class scl here.
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
#    class { 'scl':
#      packages => [ 'rh-ruby22', 'ruby193' ],
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
# Copyright 2016 Jacob Castello, unless otherwise noted.
#
class scl (
  Boolean $manage_repos      = true,
  Boolean $repo_enabled_sclo = $scl::params::repo_enabled_sclo,
  String $repo_present_sclo  = $scl::params::repo_present_sclo,
  String $repo_url_sclo      = $scl::params::repo_url_sclo,
  Boolean $repo_enabled_rh   = $scl::params::repo_enabled_rh,
  String $repo_present_rh    = $scl::params::repo_present_rh,
  String $repo_url_rh        = $scl::params::repo_url_rh,
  String $repo_gpg_key       = $scl::params::repo_gpg_key,
  String $os_maj_release     = $scl::params::os_maj_release,
  $packages                  = $scl::params::packages,
  String $gem_source         = $scl::params::gem_source,
  $shebangs                  = $scl::params::shebangs
) inherits scl::params {

  if $manage_repos == true {
    include scl::repos
  }

  # This shebang line is
  # the overarching 'enable'
  # needed for all other
  # package shebangs
  file { 'scl-shebang':
    ensure  => file,
    path    => '/usr/local/bin/scl-shebang',
    owner   => 'root',
    group   => '0',
    mode    => '0755',
    content => template('scl/scl-shebang.erb'),
  }

  if $shebangs != undef {

    validate_array($shebangs)

    scl::shebang { $shebangs: }
  }

  if $packages != undef {

    validate_array($packages)

    scl::package { $packages:
      require => Yumrepo['CentOS-SCLo-scl-rh', 'CentOS-SCLo-scl'],
    }
  }
}
