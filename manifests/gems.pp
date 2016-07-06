# Create the individual
# gems from scl::ruby, using the
# appropriate gem provider and
# a unique resource name
define scl::gems (
  String $scl_ruby_version = undef,
  Hash $scl_gems = hiera("scl::${scl_ruby_version}::gems", {}),
  String $ensure = 'present',
  String $source = 'https://rubygems.org'
) {

  $scl_gem_long = suffix( $scl_gems, "-${scl_ruby_version}")

  $scl_gem_provider = regsubst( $scl_ruby_version, '-', '_', 'G')

  $gem_defaults = {
    ensure   => $ensure,
    provider => "${scl_gem_provider}_gem",
    source   => $source,
  }

  ensure_packages($scl_gem_long, $gem_defaults)

}
