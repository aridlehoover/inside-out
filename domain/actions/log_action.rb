class LogAction
  attr_reader :logger, :service, :user, :params

  def initialize(logger:, service:, user:, params: {})
    @logger = logger
    @service = service
    @user = user
    @params = params
  end

  def on_success(record)
  end

  def on_failure
  end
end
