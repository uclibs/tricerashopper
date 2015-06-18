require 'spec_helper'

describe Order do
  
  it "has a valid factory" do 
    expect(build(:order)).to be_valid
  end

  it "is valid with title" do 
    expect(build(:order, title: 'test')).to be_valid
    end

  it "is invalid without a title" do
    expect(build(:order, title: nil)).to be_invalid
  end

  it "is valid with an author" do
    expect(build(:order, author: 'test')).to be_valid
  end

  it "is invalid without an author" do
    expect(build(:order, author: nil)).to be_invalid
  end

  it "is valid with a publication date" do
    expect(build(:order, publication_date: '2001')).to be_valid
  end

  it "is invalid without a publication date" do
    expect(build(:order, publication_date: nil)).to be_invalid
  end

  it "is valid with a publisher" do
    expect(build(:order, publisher: 'test')).to be_valid
  end

  it "is invalid without a publisher" do
    expect(build(:order, publisher: nil)).to be_invalid
  end

  it "is valid with series" do
    expect(build(:order, series: 'test')).to be_valid
  end

   it "is valid with a selector" do
    expect(build(:order, selector: 'test')).to be_valid
  end

  it "is invalid without a selector" do
    expect(build(:order, selector: nil)).to be_invalid
  end

  it "is valid with a location code" do
    expect(build(:order, location_code: 'test')).to be_valid
  end
 
  it "is invalid without a location code" do
    expect(build(:order, location_code: nil)).to be_invalid
  end

  it "is valid with a fund" do
    expect(build(:order, fund: 'test')).to be_valid
  end
 
  it "is invalid without a fund" do
    expect(build(:order, fund: nil)).to be_invalid
  end

  it "is valid with a cost" do
    expect(build(:order, cost: 2000)).to be_valid
  end

  it "is valid with currency" do
    expect(build(:order, currency: 'USD')).to be_valid
  end

  it "is invalid without currency" do
    expect(build(:order, currency: nil)).to be_invalid
  end
end
