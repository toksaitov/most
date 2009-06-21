class MostException
  attr_reader :message

  def initialize(message = "An empty exception instance")
    @message = message.to_s
  end
end