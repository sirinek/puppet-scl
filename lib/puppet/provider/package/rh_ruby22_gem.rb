require 'puppet/provider/package'

# Ruby gems support
Puppet::Type.type(:package).provide(:rh_ruby22_gem, :parent => :gem) do
  desc "This scl embedded gem command relies on the small, but important shebang
  script in /usr/local/bin/scl-shebang-rh-ruby22 created by the scl module."

  has_feature :versionable, :install_options

  commands :gemcmd => "/usr/local/bin/scl-shebang-gem-rh-ruby22"
end
