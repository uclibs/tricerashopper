class BlankRdate < Problem
  include ProblemLogic

  before_validation :set_fields
  validate :validation
  validates :record_num, uniqueness: true
  DESCRIPTION = 'Order rdate is blank but status is marked paid'

  def self.model_name
    Problem.model_name
  end

  def validation
    errors.add(:query, "no match") unless query
  end

  def query
    load_order_view
    order_status_code_is_a and
    order_is_more_than_4_months_old and
    order_received_date_is_nil and
    order_cataloging_date_is_not_nil and
    order_acq_type_is_p
  end

  private

  def load_order_view
    @order_view ||= OrderView.where(record_num: self.record_num).first
  end

  def set_fields
    load_order_view
    self.title = @order_view.bib_view.title
    self.record_type = @order_view.record_type_code
  end
end
