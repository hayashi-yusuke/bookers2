class GroupMailer < ApplicationMailer

  def notice(group, member, title, body)
    # メールの中で使う変数
    @group  = group
    @member = member
    @title  = title
    @body   = body

    # メールを送る
    mail(
      to: member.email_address,
      subject: title
    )
  end

end