class OrderMailer < ActionMailer::Base
  default from: "NO-REPLY@lucy.libraries.uc.edu"

  def new_order(user, order)
      @user = user
      @order = order
      mail(to: @user.email, cc: Admin.pluck(:email), subject: 'Tricerashopper order confirmation')
  end
end
