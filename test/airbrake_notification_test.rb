require "test_helper"

class AirbrakeNotificationTest < TestCase
  def setup
    super
    
    @notification = AirbrakeNotification.new(api_key: "111123",
                                             rails_env: "production",
                                             local_username: "Super User",
                                             scm_revision: "130487dsfiguha",
                                             scm_repository: "git@github.com:ubiregiinc/ping.git")
  end

  attr_reader :notification

  def test_send_notification
    stub_request :any, "http://airbrake.io/deploys"

    notification.notify!

    assert_requested :post, "http://airbrake.io/deploys" do |request|
      body = URI.decode_www_form(request.body)
      assert_includes body, ["api_key","111123"]
      assert_includes body, ["deploy[rails_env]", "production"]
      assert_includes body, ['deploy[local_username]', "Super User"]
      assert_includes body, ["deploy[scm_revision]", "130487dsfiguha"]
      assert_includes body, ['deploy[scm_repository]', "git@github.com:ubiregiinc/ping.git"]
    end
  end
end
