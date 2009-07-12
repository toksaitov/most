module Most
  module Helpers
    module Utilities

      class MostReplacer
        attr_accessor :rules_hash

        def initialize(new_rules_hash = nil)
          @rules_hash = new_rules_hash
        end

        def process(data_string, rules_hash = nil)
          result = ""

          result = replace(data_string, rules_hash)
          result = replace(result, @rules_hash)

          return result
        end

        private
        def replace(data_string, rules_hash)
          result = ""

          if data_string
            result = data_string

            rules_hash.each do |pattern, value|
              result = data_string.gsub(pattern, value)
            end if rules_hash
          end

          return result
        end
      end

    end
  end
end