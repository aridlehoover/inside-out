require_relative '../../domain/builders/import_alerts_builder'
require_relative '../../domain/value_objects/feed'
require_relative '../../adapters/notifiers/notifier_factory'

class AlertsController
  def import
    ImportAlertsBuilder.new(logger: logger, user: current_user, reader: reader, feed: feed)
      .with_notification(factory: factory)
      .with_http_response(controller: controller)
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

  def controller
    self
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
