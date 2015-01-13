class Lost < ActiveRecord::Base
  validates :item_number, presence: true
  validates :bib_number, presence: true
  validates :location, presence: true

  before_save :hyphen_for_nil

  searchable do
    text :title, :location, :call_number, :class_trunc, :class_full, :loc_trunc
    string :title
    string :call_number
    string :class_full
    string :location
    string :loc_trunc 
    string :class_trunc
  end

  def class_full
    match = /^[a-z\-]{,4}([A-Z]{1,3})\d/.match(self.call_number)
    return self.call_number if match.nil?
    match[1]
  end

  def class_trunc
    match = /^[a-z\-]{,4}([A-Z])[A-Z]{0,2}\d/.match(self.call_number)
    return "Other" if match.nil?
    match[1]
  end

  def loc_trunc
    if self.location[0] == 'u'
      self.location[0..2]
    elsif self.location[0] == 'h'
      self.location = 'HSL'
    elsif self.location =~ /tdp/
      self.location = 'SWORD'
    else 
      self.location = 'Other'
    end
  end 
      
  def hyphen_for_nil
    self.isbn = self.isbn.presence || '-'
    self.imprint = self.imprint.presence || '-'
    self.barcode = self.barcode.presence || '-'
    self.note = self.note.presence || '-'
    self.call_number = self.call_number.presence || '-'
    self.volume = self.volume.presence || '-'
  end
end
