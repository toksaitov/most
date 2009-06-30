module Most
  module Helpers
    module Utilities

      class MostReplacer
        attr_accessor :rules_hash

        def initialize(new_rules_hash = nil)
          @rules_hash = new_rules_hash
        end

        def process(data_string, rules_hash = @rules_hash)
          if data_string and rules_hash
            rules_hash.each do |pattern, value|
              data_string.gsub!(pattern, value)
            end
          end

          return data_string
        end
      end

    end
  end
end