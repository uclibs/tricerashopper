require 'spec_helper'

describe Lost do
  it "has a valid factory" do
    expect(build(:lost)).to be_valid
  end
  
  it "is valid with an item_number" do
    expect(build(:lost)).to be_valid
  end

  it "is invalid without an item_number" do
    expect(build(:lost, item_number: nil)).to be_invalid
  end

  it "is valid with a bib_number" do
    expect(build(:lost)).to be_valid
  end

  it "is invalid without a bib_number" do
    expect(build(:lost, bib_number: nil)).to be_invalid
  end

  it "is valid with a location" do
    expect(build(:lost)).to be_valid
  end

  it "is invalid without a location" do
    expect(build(:lost, location: nil)).to be_invalid
  end


  context "class_full" do
    it "returns the full class for call_number case #1" do
      lost = build(:lost, call_number: "AB1")
      expect(lost.class_full).to match /AB/
    end

    it "returns the full class for call_number case #2" do
      lost = build(:lost, call_number: "A1")
      expect(lost.class_full).to match /A/
    end

    it "returns the full class for call_number case #3" do
      lost = build(:lost, call_number: "chemA1")
      expect(lost.class_full).to match /A/
    end

    it "returns the full class for call_number case #4" do
      lost = build(:lost, call_number: "chemAB1")
      expect(lost.class_full).to match /AB/
    end

    it "returns the full class for call_number case #5" do
      lost = build(:lost, call_number: "geoAB1")
      expect(lost.class_full).to match /AB/
    end

    it "returns the full class for call_number case #6" do
      lost = build(:lost, call_number: "geoA1")
      expect(lost.class_full).to match /A/
    end

    it "returns the full class for call_number case #7" do
      lost = build(:lost, call_number: "ABC1")
      expect(lost.class_full).to match /ABC/
    end

    it "returns the full class for call_number case #8" do
      lost = build(:lost, call_number: "chemABC1")
      expect(lost.class_full).to match /ABC/
    end

    it "returns the full class for call_number case #9" do
      lost = build(:lost, call_number: "geoABC1")
      expect(lost.class_full).to match /ABC/
    end

    it "returns the full class for call_number case #10" do
      lost = build(:lost, call_number: "cl-gABC1")
      expect(lost.class_full).to match /ABC/
    end

    it "returns the full class for call_number case #11" do
      lost = build(:lost, call_number: "cl-gAB1")
      expect(lost.class_full).to match /AB/
    end

    it "returns the full class for call_number case #12" do
      lost = build(:lost, call_number: "cl-gA1")
      expect(lost.class_full).to match /A/
    end

    it "returns itself for other call_number cases" do
      lost = build(:lost, call_number: "Newspaper")
      expect(lost.class_full).to eq "Newspaper" 
    end
  end

  context "class_trunc" do
    it "returns the beginning of the class for call_number case #1" do
      lost = build(:lost, call_number: "A1")
      expect(lost.class_trunc).to eq "A"
    end

    it "returns the beginning of the class for call_number case #2" do
      lost = build(:lost, call_number: "AB1")
      expect(lost.class_trunc).to eq "A"
    end

    it "returns the beginning of the class for call_number case #3" do
      lost = build(:lost, call_number: "chemAB1")
      expect(lost.class_trunc).to eq "A"
    end

    it "returns the beginning of the class for call_number case #4" do
      lost = build(:lost, call_number: "chemAB1")
      expect(lost.class_trunc).to eq "A"
    end

    it "returns itself for other call_number cases" do
      lost = build(:lost, call_number: "Foo")
      expect(lost.class_trunc).to match /Other/
    end
  end

  context "loc_trunc" do
    it "returns the shortened location code for u* locations" do
      lost = build(:lost, location: "uenjr")
      expect(lost.loc_trunc).to eq "uen"
    end

    it "returns HSL as a location" do
      lost = build(:lost, location: "hint")
      expect(lost.loc_trunc).to eq "HSL"
    end

    it "returns SWORD as a location" do
      lost = build(:lost, location: "tdpst")
      expect(lost.loc_trunc).to eq "SWORD"
    end

    it "returns Other for other locations" do
      lost = build(:lost, location: "foo")
      expect(lost.loc_trunc).to eq "Other"
    end
  end

end
