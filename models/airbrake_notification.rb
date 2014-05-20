class AirbrakeNotification
  def initialize(api_key:, rails_env:, scm_repository:, scm_revision:, local_username:)
    @api_key = api_key
    @rails_env = rails_env
    @repository = scm_repository
    @revision = scm_revision
    @username = local_username
  end

  def notify!
    body = { 'deploy[rails_env]' => @rails_env, 'api_key' => @api_key, 'deploy[local_username]' => @username, 'deploy[scm_revision]' => @revision, 'deploy[scm_repository]' => @repository }
    HTTPClient.new.post_content "http://airbrake.io/deploys", body
  end
end
