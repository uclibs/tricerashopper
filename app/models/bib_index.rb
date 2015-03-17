class BibIndex < SierraIndex
  after_initialize :init

  def init
    self.record_type = "b"
  end
end
