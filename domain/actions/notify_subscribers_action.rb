class NotifySubscribersAction
  attr_reader :notifier_factory

  def initialize(notifier_factory:)
    @notifier_factory = notifier_factory
  end
end
