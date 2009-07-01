module Most
  module Helpers  
    module Exceptions

      class MostException < Exception
        def initialize()
          super(Most::Lang.exept_default_msg)
        end
      end

    end
  end
end