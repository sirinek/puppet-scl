# Manage rubies specifically
# by default includes the *ruby-devel and
# * rubygems-devel packages needed to build gems
#
# Also includes a shebang file/script that enables
# a user and the scl-gem provider to use
# an scl-packaged version of ruby to call gem
# in the correct path
define scl::package (
  String $scl_package = $title,
) {
  package { $scl_package:
    ensure  => present,
  }
}
