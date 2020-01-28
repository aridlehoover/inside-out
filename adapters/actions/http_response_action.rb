class HttpResponseAction
  attr_reader :controller

  def initialize(controller)
    @controller = controller
  end
end