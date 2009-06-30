require 'yaml'

require File.expand_path(File.dirname(__FILE__)) + '/most_format_provider'

module Most
  module Helpers
    module Formats
      
      class YamlFormatProvider < MostFormatProvider

        def to_format(data_string)
          return data_string.to_yaml()
        end

        def revert(yaml_string)
          return YAML::load(yaml_string)
        end
      end
    end

  end
end