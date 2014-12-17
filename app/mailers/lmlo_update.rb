class LmloUpdate < ActionMailer::Base
  default from: "lmlo@larry.libraries.uc.edu"

  def new_report(user)
    @user = user
    mail(to: @user.email, subject: 'new lmlo items for review')
  end
end
