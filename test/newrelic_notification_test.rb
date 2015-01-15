require 'test_helper'

class NewrelicNotificationTest < TestCase
  def setup
    super

    @notification = NewrelicNotification.new(api_key: "topsecret",
                                             app_id: 111123,
                                             user: "Super User",
                                             revision: "130487dsfiguha",
                                             git_log: "log message")
  end

  attr_reader :notification

  def test_send_notification
    stub_request :any, "https://api.newrelic.com/deployments.xml"

    notification.notify!

    assert_requested :post, "https://api.newrelic.com/deployments.xml" do |request|
      assert_equal "topsecret", request.headers["X-Api-Key"]

      body = URI.decode_www_form(request.body)
      assert_includes body, ["deployment[application_id]","111123"]
      assert_includes body, ["deployment[revision]", "130487dsfiguha"]
      assert_includes body, ["deployment[changelog]", "log message"]
      assert_includes body, ['deployment[user]', "Super User"]
    end
  end

  def test_notification_failure_by_HTTP_status_code
    stub_request(:any, "https://api.newrelic.com/deployments.xml").to_return(:body => "abc", :status => 400)

    assert_raises HTTPClient::BadResponseError do
      notification.notify!
    end
  end

  def test_validation_should_test_app_id_and_api_key_to_be_present
    notification = NewrelicNotification.new(api_key: "", app_id: "", user: nil, revision: nil, git_log: nil)
    refute notification.valid?
    assert_equal [:api_key, :app_id], notification.errors.keys
  end
end
