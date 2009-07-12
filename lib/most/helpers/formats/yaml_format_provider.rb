require 'yaml'

require File.expand_path(File.dirname(__FILE__)) + '/most_format_provider'

module Most
  module Helpers
    module Formats
      
      class YamlFormatProvider < MostFormatProvider
        FORMAT_EXTENSION = 'yml'

        def to_format(data_string)
          return data_string.to_yaml()
        end
        
        def from_format(yaml_string)
          return YAML::load(yaml_string)
        end
        
        def format_extension(file_name = nil)
          return file_name ? "#{file_name}.#{FORMAT_EXTENSION}" : FORMAT_EXTENSION
        end
      end
    end

  end
end