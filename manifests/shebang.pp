#
# Creates the necessary hashbang file for the relevant installed
# packages
#
# example
# -------
# scl::shebang { 'ruby193': }
#
# creates the file '/usr/local/bine/scl-shebang-ruby193'
#
define scl::shebang (
  String $scl_package = $name,
) {

  file { "scl-shebang-${name}":
    ensure  => file,
    path    => "/usr/local/bin/scl-shebang-${name}",
    owner   => 'root',
    group   => '0',
    mode    => '0755',
    content => template('scl/scl-shebang-package.erb'),
  }
}
