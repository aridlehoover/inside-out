require_relative '../actions/log_action'
require_relative '../actions/http_response_action'
require_relative '../actions/notification_action'

class ImportAlertsBuilder
  attr_reader :logger, :user, :reader, :feed, :actions

  def initialize(logger:, user:, reader:, feed:)
    @logger = logger
    @user = user
    @reader = reader
    @feed = feed
    @actions = []
    @actions << LogAction.new(logger: logger, service: :import_alerts, user: user, params: { feed: feed })
  end

  def with_http_response(controller:)
    actions << HTTPResponseAction.new(controller: controller)
    self
  end

  def with_notification(factory:)
    actions << NotificationAction.new(logger: logger, user: user, factory: factory)
    self
  end

  def build
    ImportAlerts.new(reader: reader, observers: actions)
  end
end
