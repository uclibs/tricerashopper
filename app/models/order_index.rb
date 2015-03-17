class OrderIndex < SierraIndex
  after_initialize :init

  def init
    self.record_type = "o"
  end
end
