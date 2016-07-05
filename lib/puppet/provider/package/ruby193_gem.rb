require 'puppet/provider/package'
require 'uri'

# Ruby gems support
Puppet::Type.type(:package).provide(:ruby193_gem, :parent => :gem) do
  desc "This scl embedded gem command relies on the small, but important shebang
  script in /usr/local/bin/scl-shebang-gem-ruby193 created by the scl module."

  has_feature :versionable, :install_options

  commands :gemcmd => "/usr/local/bin/scl-shebang-gem-ruby193"

end
