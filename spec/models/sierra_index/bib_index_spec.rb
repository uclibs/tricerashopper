require 'spec_helper'

describe BibIndex do

  subject { BibIndex.new }

  it { should respond_to(:record_type) }
  it { should respond_to(:record_num) }
  it { should respond_to(:last_checked) }

  it "has a valid factory" do
    expect(build(:bib_index)).to be_valid
  end

  it "is valid with record number" do
    expect(build(:bib_index, record_num: 123456 )).to be_valid
  end

  it "is invalid without record number" do
    expect(build(:bib_index, record_num: nil )).to be_invalid
  end

  it "has record_type: 'b'" do
    expect(build(:bib_index, record_type: 'b' )).to be_valid
  end
end
