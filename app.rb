require 'sinatra/base'

require_relative "models/newrelic_notification"
require_relative "models/airbrake_notification"
require_relative "models/slack_notification"

class Server < Sinatra::Base
  post '/notify' do
    if ENV['NEWRELIC_API_KEY'] and ENV['NEWRELIC_APP_ID']
      nn = NewrelicNotification.new(api_key: ENV['NEWRELIC_API_KEY'],
                                    app_id: ENV['NEWRELIC_APP_ID'],
                                    user: params[:user],
                                    revision: params[:head_long],
                                    git_log: params[:git_log])

      nn.notify! if nn.valid?
    end

    if ENV['AIRBRAKE_API_KEY'] and ENV['AIRBRAKE_RAILS_ENV'] and ENV['AIRBRAKE_REPOSITORY']
      an = AirbrakeNotification.new(api_key: ENV['AIRBRAKE_API_KEY'],
                                    rails_env: ENV['AIRBRAKE_RAILS_ENV'],
                                    local_username: params[:user],
                                    scm_revision: params[:head_long],
                                    scm_repository: ENV['AIRBRAKE_REPOSITORY'])

      an.notify!
    end

    if ENV["SLACK_HOOK_URL"]
      sn = SlackNotification.new(hook_url: ENV["SLACK_HOOK_URL"],
                                 app: params[:app],
                                 revision: params[:head_long],
                                 git_log: params[:git_log])
      sn.notify!
    end

    "ok"
  end
end
