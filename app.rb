require 'sinatra/base'

require_relative "models/newrelic_notification"

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

    "ok"
  end
end
