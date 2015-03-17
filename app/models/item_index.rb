class ItemIndex < SierraIndex
  after_initialize :init

  def init
    self.record_type = "i"
  end
end
