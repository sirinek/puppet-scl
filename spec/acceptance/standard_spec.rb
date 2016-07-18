require 'spec_helper_acceptance'

describe 'scl class' do

  context 'default parameters' do
    it 'should work with no errors based on the example' do
      pp = <<-EOS
      class { 'scl':
        packages => ['rh-ruby22'],
      }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end
end
