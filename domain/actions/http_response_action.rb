class HTTPResponseAction
  attr_reader :controller

  def initialize(controller: controller)
    @controller = controller
  end

  def on_success(record)
  end

  def on_failure
  end
end
