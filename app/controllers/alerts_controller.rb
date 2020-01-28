require_relative '../../adapters/builders/import_alerts_builder'
require_relative '../../domain/value_objects/feed'

class AlertsController
  def import
    ImportAlertsBuilder.new(feed)
      .with_change_log
      .with_http_response(self)
      .with_subscriber_notification
      .build
      .perform
  end

  private

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