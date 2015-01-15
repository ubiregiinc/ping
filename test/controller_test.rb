require 'test_helper'

class ControllerTest < TestCase
  include Rack::Test::Methods

  def setup
    super

    ENV['NEWRELIC_API_KEY'] = 'example'
    ENV['NEWRELIC_APP_ID'] = '123456'

    ENV['AIRBRAKE_API_KEY'] = 'airbrake_api_key'
    ENV['AIRBRAKE_RAILS_ENV'] = 'production'
    ENV['AIRBRAKE_REPOSITORY'] = 'git@github.com:ubiregiinc/ping.git'

    ENV["SLACK_HOOK_URL"] = "https://example.com/hook"
  end

  def teardown
    super

    ENV.delete('NEWRELIC_API_KEY')
    ENV.delete('NEWRELIC_APP_ID')
    ENV.delete('AIRBRAKE_API_KEY')
    ENV.delete('AIRBRAKE_RAILS_ENV')
    ENV.delete('AIRBRAKE_REPOSITORY')
    ENV.delete("SLACK_HOOK_URL")
  end

  def app
    Server
  end

  def test_sending_notifications
    mock.proxy(NewrelicNotification).new(api_key: "example", app_id: "123456", user: "soutaro", revision: "testtest", git_log: "Git Log Message") {|n|
      mock(n).notify!
    }

    mock.proxy(AirbrakeNotification).new(api_key: "airbrake_api_key", rails_env: "production", scm_repository: "git@github.com:ubiregiinc/ping.git", scm_revision: "testtest", local_username: "soutaro") do |n|
      mock(n).notify!
    end

    mock.proxy(SlackNotification).new(hook_url: "https://example.com/hook", app: "finger and register", revision: "testtest", git_log: "Git Log Message") do |n|
      mock(n).notify!
    end

    post '/notify', { "app" => "finger and register", "user" => "soutaro", "head_long" => "testtest", 'git_log' => "Git Log Message"}

    assert last_response.ok?
  end
end
