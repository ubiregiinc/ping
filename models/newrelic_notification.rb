require "active_model"
require 'httpclient'

class NewrelicNotification
  include ActiveModel::Validations
  attr_reader :api_key, :app_id, :user, :revision, :git_log

  validates_presence_of :api_key, :app_id

  def initialize(api_key:, app_id:, user:, revision:, git_log:)
    @api_key = api_key
    @app_id = app_id
    @revision = revision
    @git_log = git_log
    @user = user
  end

  def notify!
    body = [
      ['deployment[application_id]', @app_id.to_s],
      ['deployment[revision]', @revision],
      ['deployment[changelog]', @git_log],
      ['deployment[user]', @user]
    ]
    HTTPClient.new.post_content "https://api.newrelic.com/deployments.xml", body, { "x-api-key" => @api_key }
  end
end
