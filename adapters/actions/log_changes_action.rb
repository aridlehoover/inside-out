class LogChangesAction
  attr_reader :service, :user, :params

  def initialize(service, user, params: {})
    @service = service
    @user = user
    @params = params
  end
end
