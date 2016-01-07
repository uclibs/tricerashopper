class OrderProblem < Problem
  include ProblemLogic

  before_validation :set_fields
  validate :validation
  validates :record_num, uniqueness: true
  
  def self.model_name
    Problem.model_name
  end

  def validation
    errors.add(:query, "no match") unless query
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
