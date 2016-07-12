require 'spec_helper'

describe 'scl::shebang' do
  let(:title){'rh-ruby22'}

  it do
    is_expected.to contain_file('/usr/local/bin/scl-shebang-rh-ruby22').with({
    'ensure' => 'file',
    'owner' => 'root',
    'group' => '0',
    'mode' => '0444',
  })
  end

  it do
    is_expected.to contain_file('/usr/local/bin/scl-shebang-rh-ruby22')\
      .with_content(/^\s*rh-ruby22$/)
  end
end
