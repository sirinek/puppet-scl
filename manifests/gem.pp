define scl::gem (
  String $scl_ruby_package = $title
){
  package { "${scl_ruby_package}-ruby-devel":
    ensure => present,
  }
  
  file { "scl-shebang-gem-${scl_ruby_package}":
    ensure  => file,
    path    => "/usr/local/bin/scl-shebang-gem-${scl_ruby_package}",
    owner   => 'root',
    group   => 'root',
    content => template('scl/scl-shebang-gem.erb'),
    mode    => '0755',
    require => [ File['scl-shebang'], Package["${scl_ruby_package}-ruby-devel"] ], 
  }
}
