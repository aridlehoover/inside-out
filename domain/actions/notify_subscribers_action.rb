class NotifySubscribersAction
  attr_reader :factory

  def initialize(factory:)
    @factory = factory
  end
end
