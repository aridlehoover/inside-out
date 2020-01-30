require_relative '../../domain/builders/notify_subscribers_builder'
require_relative '../../adapters/notifiers/notifier_factory'
require_relative '../../domain/repositories/alert_repository'

class NotificationsController
  def create
    NotifySubscribersBuilder.new(logger: logger, user: current_user, factory: factory, alerts: alert)
      .with_http_response(controller: controller)
      .build
      .perform
  end

  private

  def alert
    AlertRepository.find_by_id(params[:alert_id])
  end

  def factory
    NotifiersFactory
  end

  def logger
    Logger
  end

  def controller
    self
  end
end
