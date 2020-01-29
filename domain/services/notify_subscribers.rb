class NotifySubscribers
  attr_reader :alerts, :factory, :repository, :observers

  def initialize(alerts:, factory:, repository: SubscriberRepository.new, observers: [])
    @alerts = alerts
    @factory = factory
    @repository = repository
    @observers = observers
  end

  def perform
    if active_alerts.any?
      subscribers.each do |subscriber|
        factory.build(subscriber).notify(active_alerts)

        observers.each { |observer| observer.on_success(subscriber) }
      end
    end
  end

  private

  def active_alerts
    @active_alerts ||= alerts.select(&:active?)
  end

  def subscribers
    @subscribers ||= repository.find_all
  end
end