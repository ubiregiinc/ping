require 'test_helper'

class NewrelicsControllerTest < ActionController::TestCase
  setup do
    ENV["NEWRELIC_API_KEY"] = "example"
    ENV["NEWRELIC_APP_ID"] = "123456"
  end

  teardown do
    ENV.delete("NEWRELIC_API_KEY")
    ENV.delete("NEWRELIC_APP_ID")
  end

  test "create should create NewrelicNotification" do
    stub_request :any, "https://api.newrelic.com/deployments.xml"

    post :create, { app_id: 123456, user: "Soutaro Matsumoto", head_long: "testtest", git_log: "Git Log Message" }

    notification = assigns("notification")
    assert_not_nil notification
    assert_equal "example", notification.instance_variable_get('@api_key')
    assert_equal "123456", notification.instance_variable_get('@app_id')
    assert_equal "Soutaro Matsumoto", notification.instance_variable_get('@user')
    assert_equal "testtest", notification.instance_variable_get('@revision')
    assert_equal "Git Log Message", notification.instance_variable_get('@git_log')
  end

  test "create should call notify" do
    stub.proxy(NewrelicNotification).new {|obj| mock(obj).notify!; obj }
    post :create, { app_id: 123456, user: "Soutaro Matsumoto", head_long: "testtest", git_log: "Git Log Message" }
  end

  test "should reject blank app_id" do
    ENV.delete "NEWRELIC_APP_ID"
    ENV.delete "NEWRELIC_API_KEY"

    post :create, { app_id: 123456, user: "Soutaro Matsumoto", head_long: "testtest", git_log: "Git Log Message" }

    assert_response :forbidden
    assert_unifiable({ "api_key" => :_, "app_id" => :_ }, JSON.parse(response.body))
  end
end
