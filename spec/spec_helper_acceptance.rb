# consul/spec/spec_helper_acceptance.rb
require 'beaker-rspec'

# Not needed for this example as our docker files have puppet installed already
#hosts.each do |host|
#  # Install Puppet #  install_puppet
#end

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
      apply_manifest_on(host, 'package { "git": }')
      modulepath = host.puppet['modulepath']
      modulepath = modulepath.split(':').first if modulepath

      environmentpath = host.puppet['environmentpath']
      environmentpath = environmentpath.split(':').first if environmentpath

      destdir = modulepath || "#{environmentpath}/production/modules"
      on host, "git clone https://github.com/smbambling/bambling-yumrepo.git #{destdir}/yumrepo"
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
