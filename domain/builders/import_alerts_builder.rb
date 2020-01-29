require_relative '../actions/log_changes_action'
require_relative '../actions/http_response_action'
require_relative '../actions/notify_subscribers_action'

class ImportAlertsBuilder
  attr_reader :reader, :actions

  def initialize(reader:)
    @reader = reader
    @actions = []
  end

  def with_change_log(logger:, user:, feed:)
    actions << LogChangesAction.new(logger: logger, service: :import_alerts, user: user, params: { feed: feed })
    self
  end

  def with_http_response(controller:)
    actions << HttpResponseAction.new(controller: controller)
    self
  end

  def with_subscriber_notification(factory:)
    actions << NotifySubscribersAction.new(factory: factory)
    self
  end

  def build
    ImportAlerts.new(reader: reader, observers: actions)
  end
end
