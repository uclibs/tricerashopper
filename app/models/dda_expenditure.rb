class DdaExpenditure < ActiveRecord::Base
before_save :trunc_fund

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
