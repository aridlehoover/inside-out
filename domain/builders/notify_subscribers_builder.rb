require_relative '../actions/log_action'
require_relative '../actions/http_response_action'

class NotifySubscribersBuilder
  attr_reader :factory, :alerts, :actions

  def initialize(logger:, user:, factory:, alerts:)
    @factory = factory
    @alerts = Array(alerts)
    @actions = []
    @actions << LogAction.new(logger: logger, service: :notify_subscribers, user: user, params: { alerts: alerts })
  end

  def with_http_response(controller:)
    actions << HTTPResponseAction.new(controller: controller)
    self
  end

  def build
    NotifySubscribers.new(alerts: alerts, factory: factory, observers: actions)
  end
end
