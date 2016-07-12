# A helper define to retain unique gem package names, but install
# them with different versions of ruby
#
define scl::gem (
  String $scl_ruby_version,
  String $source,
  String $ensure = 'present',
){

  $scl_gem_provider = regsubst( $scl_ruby_version, '-', '_', 'G')
  $scl_gem_name = regsubst($name, "-${scl_ruby_version}", '')

  package { $name:
    ensure          => $ensure,
    name            => $scl_gem_name,
    provider        => "${scl_gem_provider}_gem",
    source          => $source,
    install_options => [ '--no-rdoc', '--no-ri'],
    require         => Package["${scl_ruby_version}-rubygems"],
  }
}
