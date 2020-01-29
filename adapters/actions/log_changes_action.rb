class LogChangesAction
  attr_reader :service, :user, :params

  def initialize(logger:, service:, user:, params: {})
    @logger = logger
    @service = service
    @user = user
    @params = params
  end
end
