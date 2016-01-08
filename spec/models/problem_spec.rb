require 'spec_helper'

describe Problem do

  subject { Problem.new }

  it { should respond_to(:title) }
  it { should respond_to(:record_num) }
  it { should respond_to(:record_type) }

  it "has a valid factory" do
    expect(build(:problem)).to be_valid
  end

  it "is valid with title" do
    expect(build(:problem, title: 'My Title')).to be_valid
  end

  it "is invalid without title" do
    expect(build(:problem, title: nil)).to be_invalid
  end

  it "is valid with record number" do
    expect(build(:problem, record_num: 12345678)).to be_valid
  end

  it "is invalid without record number" do
    expect(build(:problem, record_num: nil)).to be_invalid
  end

  it "is valid with record_type" do
    expect(build(:problem, record_type: 'o')).to be_valid
  end

  it "is invalid wihtout record_type" do 
    expect(build(:problem, record_type: nil)).to be_invalid
  end

end
