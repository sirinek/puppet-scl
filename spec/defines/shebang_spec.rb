require 'spec_helper'

describe 'scl::shebang' do
  let(:title){'rh-ruby22'}

  it do
    is_expected.to contain_file('scl-shebang-rh-ruby22').with({
    'ensure' => 'file',
    'owner' => 'root',
    'group' => '0',
    'mode' => '0755',
  })
  end

  it do
    is_expected.to contain_file('scl-shebang-rh-ruby22')\
      .with_content("#!/usr/local/bin/scl-shebang enable rh-ruby22 -- bash\n$@\n")
  end
end
