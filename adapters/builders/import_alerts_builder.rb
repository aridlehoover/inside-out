require_relative '../actions/log_changes_action'
require_relative '../actions/http_response_action'
require_relative '../actions/notify_subscribers_action'
require_relative '../factories/reader_factory'

class ImportAlertsBuilder
  attr_reader :feed, :user, :actions

  def initialize(feed:, user:)
    @feed = feed
    @actions = []
  end

  def with_change_log(user, params)
    actions << LogChangesAction.new(:import_alerts, user: user, params: params)
    self
  end

  def with_http_response(params)
    actions << HttpResponseAction.new(params)
    self
  end

  def with_subscriber_notification
    actions << NotifySubscribersAction.new
    self
  end

  def build
    ImportAlerts.new(reader: reader, observers: actions)
  end

  private

  def reader
    ReaderFactory.build(feed)
  end
end
