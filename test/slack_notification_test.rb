require 'test_helper'

class SlackNotificationTest < TestCase
  def setup
    super

    @notification = SlackNotification.new(hook_url: "https://example.com/test",
                                          app: "ubiregi-server",
                                          revision_url: "https://example.com/owner/repo/commit/130487dsfiguha",
                                          revision: "130487dsfiguha",
                                          git_log: "log message")
  end

  attr_reader :notification

  def test_send_notification
    stub_request :any, "https://example.com/test"

    notification.notify!

    assert_requested :post, "https://example.com/test"
  end

  def test_notification_failure_by_HTTP_status_code
    stub_request(:any, "https://example.com/test").to_return(:body => "abc", :status => 400)

    assert_raises HTTPClient::BadResponseError do
      notification.notify!
    end
  end
end
