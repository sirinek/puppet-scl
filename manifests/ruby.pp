# Manage rubies specifically
# by default includes the *ruby-devel and
# * rubygems-devel packages needed to build gems
#
# Also includes a shebang file/script that enables
# a user and the scl-gem provider to use
# an scl-packaged version of ruby to call gem
# in the correct path
define scl::ruby (
  String $scl_ruby_package = $title,
  Boolean $include_ruby_devel = $scl::include_ruby_devel,
  Boolean $include_ruby_gem = $scl::include_ruby_gem
){
  package { $scl_ruby_package:
    ensure  => present,
  }

  scl::shebang { $scl_ruby_package: }

  if $include_ruby_gem == true {
    package { "${scl_ruby_package}-rubygems":
      ensure => present,
    }

    file { "scl-shebang-gem-${scl_ruby_package}":
      ensure  => file,
      path    => "/usr/local/bin/scl-shebang-gem-${scl_ruby_package}",
      owner   => 'root',
      group   => 'root',
      content => template('scl/scl-shebang-gem.erb'),
      mode    => '0755',
      require => [ File['scl-shebang'], Package["${scl_ruby_package}-rubygems"], Scl::Shebang[$scl_ruby_package] ],
    }
  }

  if $include_ruby_devel == true {
    $devel_packages = [ "${scl_ruby_package}-rubygems-devel", "${scl_ruby_package}-ruby-devel" ]
    package { $devel_packages:
      ensure => present,
    }
  }
}
