require "json"

class SlackNotification
  include ActiveModel::Validations
  attr_reader :hook_url, :revision_url, :revision, :git_log, :app

  validates_presence_of :hook_url, :app, :revision_url, :revision, :git_log

  def initialize(hook_url:, app:, revision_url:, revision:, git_log:)
    @hook_url = hook_url
    @app = app
    @revision_url = revision_url
    @revision = revision
    @git_log = git_log
  end

  def notify!
    pointer = if revision_url
                "<#{revision_url}|#{revision}>"
              else
                revision
              end
    message = "#{app} is deployed: #{pointer}"
    HTTPClient.new.post_content hook_url, { text: message }.to_json
  end
end
