require 'test_helper'

class NewrelicNotificationTest < ActiveSupport::TestCase
  setup do
    @notification = NewrelicNotification.new(api_key: "topsecret",
                                             app_id: 111123,
                                             user: "Super User",
                                             revision: "130487dsfiguha",
                                             git_log: "log message")
  end

  attr_reader :notification

  test "send notification" do
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

  test "Notification failure by HTTP status code" do
    stub_request(:any, "https://api.newrelic.com/deployments.xml").to_return(:body => "abc", :status => 400)

    assert_raise HTTPClient::BadResponseError do
      notification.notify!
    end
  end

  test "validation should test app_id and api_key have to be present" do
    notification = NewrelicNotification.new(api_key: "", app_id: "", user: nil, revision: nil, git_log: nil)
    refute notification.valid?
    assert_equal [:api_key, :app_id], notification.errors.keys
  end
end
