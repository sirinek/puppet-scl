# Manage rubies specifically
# by default includes the *ruby-devel and
# * rubygems-devel packages needed to build gems
#
# Also includes a shebang file/script that enables
# a user and the scl-gem provider to use
# an scl-packaged version of ruby to call gem
# in the correct path
define scl::python (
  String $scl_python_package = $title,
  Boolean $include_python_devel = $scl::include_python_devel,
  String $pip_source = $scl::pip_source,
  $pip_hash = hiera_hash("scl::${scl_python_package}::pips", undef)
) {
  package { $scl_python_package:
    ensure  => present,
  }

  scl::shebang { $scl_python_package: }

  if $include_python_devel == true {
    $devel_packages = [ "${scl_ruby_package}-python-devel" ]
    package { $devel_packages:
      ensure => present,
    }
  }
}
