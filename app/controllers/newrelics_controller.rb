class NewrelicsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    @notification = NewrelicNotification.new(api_key: ENV["NEWRELIC_API_KEY"], app_id: ENV["NEWRELIC_APP_ID"], user: params[:user], revision: params[:head_long], git_log: params[:git_log])

    if @notification.valid?
      @notification.notify!
      render status: :ok, nothing: true
    else
      render status: :forbidden, json: @notification.errors.as_json
    end
  end
end
