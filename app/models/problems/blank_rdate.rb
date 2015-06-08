class BlankRdate < Problem

  def self.model_name
    Problem.model_name
  end

  before_validation :select 
  validate :query

  def query
    errors.add(:query, "no match") unless (
      order_status_code_is_a and
      order_is_more_than_4_months_old and
      received_date_is_nil and
      cataloging_date_is_not_nil and
      acq_type_is_p
    )
  end

private
  def select
    @ov = OrderView.where(record_num: self.record_num).first
    self.title = @ov.bib_view.title
    self.record_type = @ov.record_type_code
  end
  
  def order_status_code_is_a
    @ov.order_status_code == 'a' 
  end

  def order_is_more_than_4_months_old
    @ov.order_date_gmt < DateTime.now - 4.months
  end
  
  def received_date_is_nil
    @ov.received_date_gmt == nil
  end

  def cataloging_date_is_not_nil
    @ov.bib_view.cataloging_date_gmt != nil 
  end

  def acq_type_is_p
    @ov.acq_type_code == 'p'
  end
end
