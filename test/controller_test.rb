require 'test_helper'

class ControllerTest < TestCase
  include Rack::Test::Methods

  def setup
    ENV["NEWRELIC_API_KEY"] = "example"
    ENV["NEWRELIC_APP_ID"] = "123456"
  end

  def teardown
    ENV.delete("NEWRELIC_API_KEY")
    ENV.delete("NEWRELIC_APP_ID")
  end

  def app
    Server
  end

  def test_should_send_notification_to_newrelic
    stub_request :any, "https://api.newrelic.com/deployments.xml"

    mock.proxy(NewrelicNotification).new(api_key: "example", app_id: "123456", user: "Soutaro Matsumoto", revision: "testtest", git_log: "Git Log Message") {|n|
      mock(n).notify!
    }

    post '/notify', { "app" => "finger and register", "user" => "Soutaro Matsumoto", "head_long" => "testtest", 'git_log' => "Git Log Message"}

    assert last_response.ok?
  end
end
