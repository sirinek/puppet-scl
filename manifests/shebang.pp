# Creates the necessary hashbang
# file for the relevant installed
# packages
#
# ex. ruby193 creates /usr/local/bin/scl-shebang-ruby193
#
define scl::shebang (
  $shebang_content = "#!/usr/local/bin/scl-shebang enable ${name} -- bash\n\$@",
  $shebang_file = "/usr/local/bin/scl-shebang-${name}"
) {
  exec { "scl-shebang-${name}":
    path        => '/bin:/usr/bin',
    command     => "echo '${shebang_content}' > ${shebang_file} && chmod +x ${shebang_file}",
    onlyif      => "scl -l | grep -v ${name}",
    unless      => "test -x ${shebang_file}",
    require     => [ Package[$name], File['scl-shebang'] ],
  }

}
