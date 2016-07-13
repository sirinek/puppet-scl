require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  config.after(:suite) do
    RSpec::Puppet::Coverage.report!(100)
  end 
end
