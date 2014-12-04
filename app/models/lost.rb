class Lost < ActiveRecord::Base
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
      if self.call_number[0..2] =~ /[A-Z][A-Z][\s0-9]/
        self.call_number[0..1]
      elsif self.call_number[0..1] =~ /[A-Z][0-9]/
        self.call_number[0] 
      elsif self.call_number[0..5] =~ /chem|phys|math|biol[A-Z][0-9]/
        self.call_number[4] 
      elsif self.call_number[0..5] =~ /chem|phys|math|biol[A-Z][A-Z]/
        self.call_number[4..5] 
      elsif self.call_number[0..4] =~ /geo[A-Z][A-Z]/
        self.call_number[3..4]
      elsif self.call_number[0..4] =~ /geo[A-Z][0-9]/
        self.call_number[3]
      else
        self.call_number = "Other"
    end
  end

  def class_trunc
    if self.call_number[0..1] =~ /[A-Z][A-Z0-9]/
      self.call_number[0]
    elsif self.call_number[0..3] =~ /chem|phys|math|biol/
      self.call_number[4] 
    elsif self.call_number[0..2] =~ /geo/
      self.call_number[3]
    else
      self.call_number
    end
  end

  def loc_trunc
    if self.location[0] == 'u'
      self.location[0..2]
    elsif self.location[0] == 'h'
      self.location = 'HSL'
    elsif self.location =~ /tdp/
      self.location = 'SWORD'
    else 
      self.location = 'OTHER'
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
