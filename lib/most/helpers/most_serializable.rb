require 'most_values'

module Most
  class MostSerializable
    attr_accessor :serializable_fields

    attr_accessor :format_provider, :store_provider

    def initialize(most_format_provider, most_store_provider)
      @serializable_fields = []

      @format_provider = most_format_provider
      @store_provider = most_store_provider
    end
  
    def serializable(*args)
      if @serializable_fields
        @serializable_fields.concat(args.compact!())
      else
        # ToDo - log error with the MostModule logger
      end

      return args
    end

    def serialize()
      if @store_provider and @format_provider and @serializable_fields
        @store_provider.save(@format_provider.to_format(@serializable_fields))
      else
        # ToDo - log error with the MostModule logger
      end
    end

    def deserialize()
      if @format_provider and @store_provider
        deserialized_fields = @format_provider.to_class(@store_provider.load())

        if is_integral(deserialized_fields, @serializable_fields)
          raise(RangeError, MostValues.MostStrings.DESR_RANGE_ERROR_MESSAGE, caller)
        end
      else
        # ToDo - log error with the MostModule logger
      end
    end

    private
    def is_integral(first_array, second_array)
      result = false

      if first_array and second_array
        first_len = first_array.length
        second_len = second_array.length

        if (first_len == second_len) and
           (first_array[0..first_len].class == second_array[0..second_len].class)
          result = true
        end
      end

      return result
    end
  end
end