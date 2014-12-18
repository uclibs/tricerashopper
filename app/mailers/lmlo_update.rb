class LmloUpdate < ActionMailer::Base
  default from: "NO-REPLY@larry.libraries.uc.edu"

  def new_report(user)
    @user = user
    mail(to: @user.email, subject: 'New LMLO items for review')
  end
end
