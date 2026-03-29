require "test_helper"

class GroupMailerTest < ActionMailer::TestCase
  test "notice" do
    mail = GroupMailer.notice
    assert_equal "Notice", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
