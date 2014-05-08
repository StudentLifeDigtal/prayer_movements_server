require 'spec_helper'

describe Movement do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:privacy) }
  it { should_not allow_value('asdfjkl').for(:website) }
  it { should allow_value('test@gmail.com', 'my@space.co.uk').for(:email) }
  it { should_not allow_value('njsdfkb').for(:email) }
  it { should allow_value('open', 'closed', 'secret').for(:privacy) }
  it { should_not allow_value('uibkjkjb').for(:privacy) }
  it do
    should ensure_length_of(:short_description).is_at_most(150).is_at_least(5)
  end
  it do
    should allow_value('http://foo.com', 'http://bar.com/baz').for(:website)
  end
end
