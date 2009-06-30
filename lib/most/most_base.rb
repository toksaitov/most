module Most

  class MostBase
    attr_reader :env

    def initialize(most_env = nil)
      if most_env
        @env = most_env
      else
        raise(RuntimeError)
      end
    end
  end

end