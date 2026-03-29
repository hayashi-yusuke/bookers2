# Preview all emails at http://localhost:3000/rails/mailers/group_mailer
class GroupMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/group_mailer/notice
  def notice
    GroupMailer.notice
  end
end
