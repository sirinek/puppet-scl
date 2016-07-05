class scl::params {
  $os_maj_release = $::os['release']['major']
  $repo_enabled_sclo = true
  $repo_present_sclo = present
  $repo_url_sclo = "http://mirror.centos.org/centos/${os_maj_release}/sclo/\$basearch/sclo/"
  $repo_enabled_rh = true
  $repo_present_rh = present
  $repo_url_rh = "http://mirror.centos.org/centos/${os_maj_release}/sclo/\$basearch/rh/"
  $repo_gpg_key = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo'
  $gem_source = 'http://rubygems.org'
  $pythons = undef
  $rubies = undef
}
