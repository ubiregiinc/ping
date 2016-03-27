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
    ENV["REVISION_URL_BASE"] = "https://example.com/owner/repo/commit/"
  end

  def teardown
    super

    ENV.delete('NEWRELIC_API_KEY')
    ENV.delete('NEWRELIC_APP_ID')
    ENV.delete('AIRBRAKE_API_KEY')
    ENV.delete('AIRBRAKE_RAILS_ENV')
    ENV.delete('AIRBRAKE_REPOSITORY')
    ENV.delete("SLACK_HOOK_URL")
    ENV.delete('REVISION_URL_BASE')
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

    mock.proxy(SlackNotification).new(hook_url: "https://example.com/hook", app: "finger and register", revision_url: "https://example.com/owner/repo/commit/testtest", revision: "testtest", git_log: "Git Log Message") do |n|
      mock(n).notify!
    end

    post '/notify', { "app" => "finger and register", "user" => "soutaro", "head_long" => "testtest", 'git_log' => "Git Log Message"}

    assert last_response.ok?
  end

  def test_sending_slack_notification_without_url
    ENV.delete('REVISION_URL_BASE')

    mock.proxy(NewrelicNotification).new(api_key: "example", app_id: "123456", user: "soutaro", revision: "testtest", git_log: "Git Log Message") {|n|
      mock(n).notify!
    }

    mock.proxy(AirbrakeNotification).new(api_key: "airbrake_api_key", rails_env: "production", scm_repository: "git@github.com:ubiregiinc/ping.git", scm_revision: "testtest", local_username: "soutaro") do |n|
      mock(n).notify!
    end

    mock.proxy(SlackNotification).new(hook_url: "https://example.com/hook", app: "finger and register", revision_url: nil, revision: "testtest", git_log: "Git Log Message") do |n|
      mock(n).notify!
    end

    post '/notify', { "app" => "finger and register", "user" => "soutaro", "head_long" => "testtest", 'git_log' => "Git Log Message"}

    assert last_response.ok?
  end
end
