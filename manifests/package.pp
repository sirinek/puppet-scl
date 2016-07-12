#
# Manage scl packages specifically use this helper in order to be able
# to distinguish between the separate packages necessary for difference
# software collections
#
define scl::package (
  String $scl_package = $title,
) {
  package { $scl_package:
    ensure  => present,
  }
}
