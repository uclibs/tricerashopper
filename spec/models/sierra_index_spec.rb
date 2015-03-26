require 'spec_helper'

describe SierraIndex do

  subject { SierraIndex.new }

  it { should respond_to(:record_type) }
  it { should respond_to(:record_num) }
  it { should respond_to(:last_checked) }

  it "has a valid factory" do
    expect(build(:sierra_index)).to be_valid
  end

  it "is invalid without record type" do
    expect(build(:sierra_index, record_type: nil )).to be_invalid
  end

  it "is invalid without record number" do
    expect(build(:sierra_index, record_num: nil )).to be_invalid
  end

  it "is invalid when duplicating another record with the same record_num and type" do
    create(:sierra_index, record_num: 12345678, record_type: 'b')
    expect(build(:sierra_index, record_num: 12345678, record_type: 'b')).to be_invalid
  end

  it "is valid with record type 'o'" do
    expect(build(:sierra_index, record_type: 'o' )).to be_valid
  end

  it "is valid with record type 'b'" do
    expect(build(:sierra_index, record_type: 'b' )).to be_valid
  end

  it "is valid with record type 'c'" do
    expect(build(:sierra_index, record_type: 'c' )).to be_valid
  end

  it "is valid with record type 'i'" do
    expect(build(:sierra_index, record_type: 'i' )).to be_valid
  end

  it "is invalid without record type [obci]" do
    expect(build(:sierra_index, record_type: 'z' )).to be_invalid
  end
end
