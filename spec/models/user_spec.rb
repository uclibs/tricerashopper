require 'spec_helper'

describe Assistant do
  it "is invalid without selector id" do
    expect(build(:assistant, selector_id: nil)).to be_invalid
  end
end

describe Selector do
  it "is invalid without location" do
    expect(build(:selector, location: nil)).to be_invalid
  end
end
