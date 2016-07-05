require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'

if RUBY_VERSION >= '1.9'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.relative = true
PuppetLint.configuration.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp']

desc 'Validate manifests, templates, and ruby files'
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb', 'lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ %r{spec/fixtures}
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

desc 'Run metadata_lint, lint, validate, and spec tests.'
task :test do
  [:metadata_lint, :lint, :validate, :spec].each do |test|
    Rake::Task[test].invoke
  end
end

namespace :puppet_git_hooks do
  desc "Install Puppet Git Hooks"
  task :install do
    begin
      hooks_rpath = File.dirname(File.readlink(".git/hooks/pre-commit"))
    rescue
      puts "Please enter the hook path [#{Dir.pwd}]"
      hook_path = $stdin.gets.strip
      if hook_path.to_s.empty?
        hook_clone = Dir.pwd
      else
        hook_clone = hook_path
      end
      if File.directory?("#{hook_clone}/.puppet-git-hooks")
        puts "Hooks already in path at #{hook_clone}. Linking."
        system("#{hook_clone}/.puppet-git-hooks/deploy-git-hook -d #{Dir.pwd} -c")
        begin
          check_hooks = File.readlink('.git/hooks/pre-commit')
        rescue Exception => e
          puts 'Failed to link git hooks'
          puts e.message
        end
      else
        puts "Hooks not found in #{hook_path}. Cloning"
        begin
          g = Git.clone('https://bitbucket.arin.net/scm/ghm/puppet-git-hooks.git', '.puppet-git-hooks', :path => hook_clone)
        rescue Exception => e
          puts ''
          puts e.message
          exit 1
        end
        puts "Successfully cloned puppet-git-hooks to #{hook_clone}"
        system("#{hook_clone}/.puppet-git-hooks/deploy-git-hook -d #{Dir.pwd} -c")
        begin
          check_hooks = File.readlink('.git/hooks/pre-commit')
        rescue Exception => e
          puts 'Failed to link git hooks'
          puts e.message
        end
        puts "Done!"
      end
    else
      puts "Git hooks already installed at #{hooks_rpath}"
    end
  end

  desc "Update Puppet Git Hooks"
  task :update do
    puts 'Updating Puppet Git Hooks...'
    repo_dir = File.dirname(File.readlink(".git/hooks/pre-commit"))
    begin
      g = Git.open(repo_dir)
    rescue Exception => e
      puts ''
      puts e.message
      exit 1
    end
    begin
      checkout = g.checkout('master')
    rescue Exception => e
      puts 'Unable to checkout master branch'
      puts e.message
      exit 1
    end
    puts checkout
    begin
      pull = g.pull
    rescue Exception => e
      puts 'Can\'t pull down origin master'
      puts e.message
      exit 1
    end
    puts pull
    puts "Done!"
  end
end
