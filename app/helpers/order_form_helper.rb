module OrderFormHelper
  
  def cost_in_dollars cost
    cost.to_d/100 if cost
  end

end
