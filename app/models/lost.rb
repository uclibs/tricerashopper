class Lost < ActiveRecord::Base
  before_save :hyphen_for_nil

  def hyphen_for_nil
    self.isbn = self.isbn.presence || '-'
    self.imprint = self.imprint.presence || '-'
    self.barcode = self.barcode.presence || '-'
    self.note = self.note.presence || '-'
    self.call_number = self.call_number || '-'
    self.volume = self.volume || '-'
  end
end
