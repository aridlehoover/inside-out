require_relative '../builders/notify_subscribers_builder'

class NotificationAction
  attr_reader :factory, :logger, :user

  def initialize(factory:, logger:, user:)
    @factory = factory
    @logger = logger
    @user = user
  end

  def on_success(alerts)
    NotifySubscribersBuilder.new(logger: logger, user: user, factory: factory, alerts: alerts)
      .build
      .perform
  end

  def on_failure; end
end
