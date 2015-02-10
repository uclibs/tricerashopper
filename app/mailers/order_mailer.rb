class OrderMailer < ActionMailer::Base
  default from: "NO-REPLY@larry.libraries.uc.edu"

  def new_order(user, order)
      @user = user
      @order = order
      mail(to: @user.email, subject: 'Tricerashopper order confirmation')
  end
end
