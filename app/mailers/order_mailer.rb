class OrderMailer < ActionMailer::Base
  default from: "NO-REPLY@lucy.libraries.uc.edu"
  add_template_helper(OrderFormHelper)

  def new_order(order)
      @order = order
      mail(to: @order.selector, bcc: Admin.pluck(:email), subject: 'Tricerashopper Order Request Confirmation')
  end
 
  def rejected_order(order)
      @order = order
      mail(to: @order.selector, subject: 'Tricerashopper Order Rejected')
  end

  def ordered_order(order)
      @order = order
      mail(to: @order.selector, subject: 'Tricerashopper Order Completed')
  end


end
