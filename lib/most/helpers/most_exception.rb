require 'most_values'

module Most
  class MostException < Exception
    def initialize()
      super(MostValues.MostStrings.DEFAULT_MESSAGE)
    end
  end
end