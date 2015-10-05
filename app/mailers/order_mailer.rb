class OrderMailer < ActionMailer::Base
  default from: "NO-REPLY@lucy.libraries.uc.edu"
  add_template_helper(OrdersHelper)

  #change bcc to cc in mailer for testing
  def new_order(order, subj)
      @order = order
      mail(to: @order.selector, bcc: Admin.pluck(:email), subject: subj)
  end

   def provisional_order(order, subj)
      @order = order
      mail(to: @order.selector, subject: subj)
  end
 
  def rejected_order(order)
      @order = order
      mail(to: @order.selector, subject: '[tricerashopper] Order Rejected')
  end

  def ordered_order(order)
      @order = order
      mail(to: @order.selector, subject: '[tricerashopper] Order Completed')
  end


end
