require "json"

class SlackNotification
  include ActiveModel::Validations
  attr_reader :hook_url, :revision, :git_log, :app

  validates_presence_of :hook_url, :app, :revision, :git_log

  def initialize(hook_url:, app:, revision:, git_log:)
    @hook_url = hook_url
    @app = app
    @revision = revision
    @git_log = git_log
  end

  def notify!
    message = "#{app} is deployed in <https://github.com/ubiregiinc/ubiregi-server/commit/#{revision}|#{revision}> as:\n#{git_log}"
    HTTPClient.new.post_content hook_url, { text: message }.to_json
  end
end
