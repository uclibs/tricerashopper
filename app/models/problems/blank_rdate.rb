class BlankRdate < Problem
  validate :query
  before_validation :select 
  def query
    @minus4months = DateTime.now - 4.months 
    unless @ov.order_status_code == 'o' && @ov.order_date_gmt < @minus4months && @ov.receive_date_gmt == nil && @ov.catalog_date_gmt != nil && @ov.acq_type_code == 'p'
    
    errors.add(:query, "no match")
    else
    errors.add(:query, "yessssss")
    end
  end   

  def select
    @ov = OrderView.where(record_num: self.record_num).first
    self.description = @ov.acq_type_code
  end
end
