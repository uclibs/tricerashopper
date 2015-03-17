class CheckinIndex < SierraIndex
  after_initialize :init

  def init
    self.record_type = "c"
  end
end
