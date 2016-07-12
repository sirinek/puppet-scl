#
# Create the individual gems from scl::ruby, using the appropriate 
# gem provider and a unique resource name
#
define scl::gems (
  String $scl_ruby_version = undef,
  Hash $scl_gems           = hiera_hash("scl::${scl_ruby_version}::gems", {}),
  String $ensure           = 'present',
  String $source           = 'https://rubygems.org',
) {

  $scl_gem_long = suffix( $scl_gems, "-${scl_ruby_version}")

  $defaults = {
    'ensure'           => present,
    'scl_ruby_version' => $scl_ruby_version,
    'source'           => $source,
  }

  create_resources( scl::gem, $scl_gem_long, $defaults)
}
