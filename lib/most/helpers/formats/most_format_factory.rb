require File.expand_path(File.dirname(__FILE__)) + '/yaml_format_provider'

module Most
  module Helpers
    module Formats

      class MostFormatFactory
        FORMAT_RULES = {:default_format => Helpers::Formats::YamlFormatProvider}

        def self.get_format(requested_format_name, *instance_args)
          result = nil

          if requested_format_name.kind_of?(Symbol)
            actual_format_name = requested_format_name
          else
            actual_format_name = :default_format
          end

          curr_class = FORMAT_RULES[actual_format_name]
          result = curr_class.new(instance_args) if curr_class

          return result
        end
      end

    end
  end
end