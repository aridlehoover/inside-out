require_relative '../repositories/alert_repository'

class ImportAlerts
  attr_reader :reader, :repository, :observers

  def initialize(reader:, repository: AlertRepository.new, observers: [])
    @reader = reader
    @repository = repository
    @observers = Array(observers).flatten
  end

  def perform
    return observers.each(&:on_failure) if feed_items.nil?

    observers.each { |observer| observer.on_success(alerts) }
  end

  private

  def feed_items
    @feed_items ||= reader.read
  end

  def alerts
    @alerts ||= feed_items.map do |feed_item|
      repository.create_from_feed_item(feed_item)
    end
  end
end
