require 'puppet/provider/package'
require 'uri'

# Ruby gems support.
Puppet::Type.type(:package).provide :ruby193_gem, :parent => Puppet::Provider::Package do
  desc "A shameless rip off of the default Puppet ruby gem provider with the scl command modified
  to incorporate changing to a Software Collection for ruby193"


  has_feature :versionable, :install_options, :uninstall_options

  commands :scl => "scl"

  def self.gemlist(options)
    gem_list_command = [command(:scl), 'enable', 'ruby193', '--', 'gem', 'list']

    if options[:local]
      gem_list_command << "--local"
    else
      gem_list_command << "--remote"
    end
    if options[:source]
      gem_list_command << "--source" << options[:source]
    end
    if name = options[:justme]
      gem_list_command << "^" + name + "$"
    end

    begin
      list = execute(gem_list_command).lines.
        map {|set| gemsplit(set) }.
        reject {|x| x.nil? }
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::Error, "Could not list gems: #{detail}", detail.backtrace
    end

    if options[:justme]
      return list.shift
    else
      return list
    end
  end

  def self.gemsplit(desc)
    # `gem list` when output console has a line like:
    # *** LOCAL GEMS ***
    # but when it's not to the console that line
    # and all blank lines are stripped
    # so we don't need to check for them

    if desc =~ /^(\S+)\s+\((.+)\)/
      gem_name = $1
      versions = $2.split(/,\s*/)
      {
        :name     => gem_name,
        :ensure   => versions.map{|v| v.split[0]},
        :provider => name
      }
    else
      Puppet.warning "Could not match #{desc}" unless desc.chomp.empty?
      nil
    end
  end

  def self.instances(justme = false)
    gemlist(:local => true).collect do |hash|
      new(hash)
    end
  end

  def insync?(is)
    return false unless is && is != :absent

    begin
      dependency = Gem::Dependency.new('', resource[:ensure])
    rescue ArgumentError
      # Bad requirements will cause an error during gem command invocation, so just return not in sync
      return false
    end

    is = [is] unless is.is_a? Array

    # Check if any version matches the dependency
    is.any? { |version| dependency.match?('', version) }
  end

  def install(useversion = true)
    command = [command(:scl), 'enable', 'ruby193', '--', 'gem', 'install']
    command << "-v" << resource[:ensure] if (! resource[:ensure].is_a? Symbol) and useversion

    if source = resource[:source]
      begin
        uri = URI.parse(source)
      rescue => detail
        self.fail Puppet::Error, "Invalid source '#{uri}': #{detail}", detail
      end

      case uri.scheme
      when nil
        # no URI scheme => interpret the source as a local file
        command << source
      when /file/i
        command << uri.path
      when 'puppet'
        # we don't support puppet:// URLs (yet)
        raise Puppet::Error.new("puppet:// URLs are not supported as gem sources")
      else
        # check whether it's an absolute file path to help Windows out
        if Puppet::Util.absolute_path?(source)
          command << source
        else
          # interpret it as a gem repository
          command << "--source" << "#{source}" << resource[:name]
        end
      end
    else
      command << "--no-rdoc" << "--no-ri" << resource[:name]
    end

    command += install_options if resource[:install_options]

    output = execute(command)
    # Apparently some stupid gem versions don't exit non-0 on failure
    self.fail "Could not install: #{output.chomp}" if output.include?("ERROR")
  end

  def latest
    # This always gets the latest version available.
    gemlist_options = {:justme => resource[:name]}
    gemlist_options.merge!({:source => resource[:source]}) unless resource[:source].nil?
    hash = self.class.gemlist(gemlist_options)

    hash[:ensure][0]
  end

  def query
    self.class.gemlist(:justme => resource[:name], :local => true)
  end

  def uninstall
    command = command = [command(:scl), 'enable', 'ruby193', '--', 'gem', 'uninstall']
    command << "--executables" << "--all" << resource[:name]

    command += uninstall_options if resource[:uninstall_options]

    output = execute(command)

    # Apparently some stupid gem versions don't exit non-0 on failure
    self.fail "Could not uninstall: #{output.chomp}" if output.include?("ERROR")
  end

  def update
    self.install(false)
  end

  def install_options
    join_options(resource[:install_options])
  end

  def uninstall_options
    join_options(resource[:uninstall_options])
  end
end
