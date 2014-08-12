class LostNotify < ActionMailer::Base
  default from: "from@example.com"

  def new_report(user)
    @user = user
    mail(to: @user.email, subject: 'test')
  end
end
