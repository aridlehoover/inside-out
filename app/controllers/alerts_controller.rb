require_relative '../../adapters/builders/import_alerts_builder'
require_relative '../../domain/value_objects/feed'

class AlertsController
  def import
    ImportAlertsBuilder.new(reader)
      .with_change_log(logger: logger, user: current_user, feed: feed)
      .with_http_response(controller: self)
      .with_subscriber_notification(factory: factory)
      .build
      .perform
  end

  private

  def reader
    ReaderFactory.build(feed)
  end

  def logger
    Logger
  end

  def factory
    NotifierFactory
  end

  def feed
    Feed.new(type: feed_type, address: address)
  end

  def feed_type
    params[:feed_type]
  end

  def address
    params[:address]
  end
end
