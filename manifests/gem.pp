# A helper define to retain unique
# gem package names, but install
# them with different versions of ruby
#
define scl::gem (
  String $scl_ruby_version,
  String $ensure = 'present',
){

  $scl_gem_provider = regsubst( $scl_ruby_version, '-', '_', 'G')

  package { $name:
    ensure   => $ensure,
    name     => regsubst($name, "-${scl_ruby_version}", ''),
    provider => "${scl_gem_provider}_gem",
    require  => Package["${scl_ruby_version}-rubygems"],
  }
}
