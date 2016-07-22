# scl

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with scl](#setup)
    * [What scl affects](#what-scl-affects)
    * [Beginning with scl](#beginning-with-scl)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Software Collection Packages](#software-collection-packages)
    * [Shebang Files](#shebang-files)
    * [Ruby Gems](#ruby-gems)
    * [Python Packages](#python-packages)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
    * [Spec Testing](#spec-testing)
    * [Serverspec Testing](#serverspec-testing)

## Description
A simple module designed to manage Software Collections on RedHat
based OS.

### What scl affects

This module will add repositories to the yum repos dir
* `/etc/yum.repos.d/`
* RPM gpg key


### Beginning with scl

This module, in its most basic form will install and manage the repositories
necessary to install Software Collections as pakcages. To do that:

```
include ::scl
```

## Usage

### Software Collection Packages

The most effective usage of the module might be to install packages that require
the scl repositories. The `scl` class takes a list of packages to install
along with the collections' repositories.

```
class { 'scl':
  packages => [ 'rh-ruby22', 'rh-ruby22-ruby-devel', 'rh-ruby22-rubygems', 'rh-ruby22-rubygems-devel' ],
  shebangs => [ 'rh-ruby22' ],
} ->
```

### Shebang Files

The parameter `shebangs` refers to files created in `/usr/local/bin/` called `scl-shebang-[package name]`
that can be used for inclusion in scripts. For example put the following in the shebang line of
a script written in ruby2.2


```
#!/usr/local/bin/scl-shebang-rh-ruby22
```

The script will properly source all necessary environment
variables for the desired ruby environment without having to declare
`scl enable rh-ruby22 -- ruby my_script.rb` each time `my_script` is run.


### Ruby Gems
When gems are included be sure to describe the version of
ruby to which the gems are being installed. Currently this
module only supports `rh-ruby22` and `ruby193`.

```
scl::gems { 'wildfly_scripts gems':
  scl_ruby_version => 'rh-ruby22',
  scl_gems         => {
    'daemons' => {},
  },
}
```

### Python Packages
Planned features in the future.


## Limitations

This module only works with RH-based operating systems, and has
been tested and developed for use with CentOS.

## Development

Development is welcome. Be sure to include spec tests for any new features added.

### Spec Testing

Currently both spec and serverspec testing is supported in this module. Efforts have been
made to streamline testing as much as possible. Spec testing should be as simple as changing
directory to the module and

```
bundle install --path vendor/bundle
bundle exec rake spec
```

### Serverspec Testing

Beaker has been leveraged for serverspec testing. Serverspec tests are limited, and
fairly shallow, but tend to get the job done. Vagrant is the modus of choice for testing
this module, and a CentOS box running Puppet Enterprise 4.4.1 has already been configured
as the default test box. Running the tests should be as simple as changing to the directory
and

```
bundle install --path vendor/bundle
bundle exec rake beaker
```
