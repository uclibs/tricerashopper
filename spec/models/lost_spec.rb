require 'spec_helper'

  describe Lost do

  describe "when lost is saved" do 

    it "should replace blank with hyphen before_save" do
      @lost = Lost.new(isbn: '')
      @lost.save
      expect(@lost.isbn).not_to eq('')
    end
  end
end
