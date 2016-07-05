# Create the individual
# gems from scl::ruby, using the
# appropriate gem provider and
# a unique resource name
define scl::gem (
  String $scl_gem_long = $name,
  String $scl_gem_type = undef,
  String $ensure = 'present',
  String $source = 'http://rubygems.org'
) {

  $scl_gem_name = regsubst( $scl_gem_long, "-${scl_gem_type}", '', 'G')

  $scl_gem_provider = regsubst( $scl_gem_type, '-', '_', 'G')

  package { $scl_gem_long:
    ensure   => $ensure,
    name     => $scl_gem_name,
    provider => "${scl_gem_provider}_gem",
    source   => $source,
  }
}
