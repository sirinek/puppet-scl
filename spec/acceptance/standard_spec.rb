require 'spec_helper_acceptance'

describe 'scl class' do

  context 'default parameters' do
    it 'should work with no errors based on the example' do
      pp = <<-EOS
      class { 'scl':
        packages => ['rh-ruby22', 'ruby193', 'rh-ruby22-rubygems', 'ruby193-rubygems'],
        shebangs => ['rh-ruby22', 'ruby193'],
      }

      scl::gems { 'rh-ruby22-gems':
        scl_ruby_version => 'rh-ruby22',
        scl_gems => { 
          daemons => {},
          },
        }
        
      scl::gems { 'ruby193-gems':
        scl_ruby_version => 'ruby193',
        scl_gems => {
          daemons => {
            ensure => '1.2.2',
            },
          },
        }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

      shell("scl -l") do |result|
          expect(result.stdout).to match(/ruby193/)
      end

      shell("scl -l") do |result|
          expect(result.stdout).to match(/rh-ruby22/)
      end

      shell("scl enable rh-ruby22 -- gem list") do |result|
          expect(result.stdout).to match(/daemons/)
      end

      shell("scl enable ruby193 -- gem list") do |result|
          expect(result.stdout).to match(/daemons \(1\.2\.2\)/)
      end
    end
    
    describe package('rh-ruby22') do
        it do
            expect(subject).to be_installed
        end
    end

    describe package('ruby193') do
        it do
            expect(subject).to be_installed
        end
    end

    describe file('/usr/local/bin/scl-shebang') do
        it "is a file" do
            expect(subject).to  be_file
        end
    end
    
    describe file('/usr/local/bin/scl-shebang-rh-ruby22') do
        it "is a file" do
            expect(subject).to  be_file
        end

        it "contains the right content" do
            expect(subject).to contain("#!/usr/local/bin/scl-shebang enable rh-ruby22 -- bash\n$@")
        end
    end

    describe file('/usr/local/bin/scl-shebang-ruby193') do
        it "is a file" do
            expect(subject).to  be_file
        end

        it "contains the right content" do
            expect(subject).to contain("#!/usr/local/bin/scl-shebang enable ruby193 -- bash\n$@")
        end
    end
  end
end
