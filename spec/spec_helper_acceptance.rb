require 'beaker-rspec'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'scl')
    hosts.each do |host|
      # Need git to fetch our modules, they're not on the forge
      modulepath = host.puppet['modulepath']
      modulepath = modulepath.split(':').first if modulepath

      environmentpath = host.puppet['environmentpath']
      environmentpath = environmentpath.split(':').first if environmentpath

      destdir = modulepath || "#{environmentpath}/production/modules"

      apply_manifest_on(host, 'package { "git": }')
      on host, "git clone https://github.com/puppetlabs/puppetlabs-stdlib #{destdir}/stdlib && cd #{destdir}/stdlib && git checkout 4.12.0"

    end
  end
end
