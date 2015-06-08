class BlankRdate < Problem

  def self.model_name
    Problem.model_name
  end

  before_validation :select 
  validate :query

  def query
    @minus4months = DateTime.now - 4.months 
    unless @ov.order_status_code == 'a' && @ov.order_date_gmt < @minus4months && @ov.received_date_gmt == nil && @ov.bib_view.cataloging_date_gmt != nil && @ov.acq_type_code == 'p'
    errors.add(:query, "no match")
    end
  end

private
  def select
    @ov = OrderView.where(record_num: self.record_num).first
    self.description = 'Order rdate is blank but status is marked paid'
    self.title = @ov.bib_view.title
    self.record_type = @ov.record_type_code
  end
end
