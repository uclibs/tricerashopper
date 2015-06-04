class DdaExpenditure < ActiveRecord::Base
before_save :trunc_fund

scope :current_month, lambda { where("paid_date >= ? AND paid_date <= ?", 
                                           Time.zone.now.beginning_of_month, Time.zone.now.end_of_month) }

  def trunc_fund
    self.fund = self.fund[1..-1]
  end

  searchable do 
    text :fund, :paid, :paid_date
    string :fund
    string :paid
    string :paid_date
  end

end
