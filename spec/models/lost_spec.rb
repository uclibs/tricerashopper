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

    it "returns 'Other' for other call_number cases" do
      lost = build(:lost, call_number: "Newspaper")
      expect(lost.class_full).to match /Other/
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

    it "returns 'Other' for other call_number cases" do
      lost = build(:lost, call_number: "Newspaper")
      expect(lost.class_trunc).to eq "Other"
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

  context "hyphen_for_nil" do
    it "replaces nil values for ISBN with '-'" do
      lost = create(:lost, isbn: nil)
      lost.reload
      expect(lost.isbn).to eq '-'
    end
    
    it "replaces nil values for imprint with '-'" do
      lost = create(:lost, imprint: nil)
      expect(lost.imprint).to eq '-'
    end

    it "replaces nil values for barcode with '-'" do
      lost = create(:lost, barcode: nil)
      expect(lost.barcode).to eq '-'
    end

    it "replaces nil values for note with '-'" do
      lost = create(:lost, note: nil)
      expect(lost.note).to eq '-'
    end

    it "replaces nil values for call_number with '-'" do
      lost = create(:lost, call_number: nil)
      expect(lost.call_number).to eq '-'
    end

    it "replaces nil values for volume with '-'" do
      lost = create(:lost, volume: nil)
      expect(lost.volume).to eq '-'
    end
  end
end
