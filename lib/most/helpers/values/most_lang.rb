require File.expand_path(File.dirname(__FILE__)) + '/../../most_serializer'

module Most
  module Helpers
    module Values

      class MostLang
        attr_reader :exec_welcome_msg,   :exec_end_msg
        attr_reader :exec_redef_err_msg, :exec_incorrect_path_msg
        attr_reader :exec_usage_msg,     :exec_options_title

        attr_reader :exept_default_msg

        def initialize(config_io_stream = nil)
          @exec_welcome_msg = "#{Most::FULL_NAME} #{Most::VERSION} has started"
          @exec_end_msg     = "#{Most::FULL_NAME} #{Most::VERSION} is about to exit"

          @exec_redef_err_msg = 'Parameter redefinition syntax is incorrect. ' +
                                'The redefenition string was "<argument>" ' +
                                'The pattern must be "<correct_pattern>".'

          @exec_incorrect_path_msg = 'The specified path is not correct. ' +
                                     'The path was "<path>".'

          @exec_usage_msg     = "Usage: #{Most::UNIX_NAME} {[option] [parameter]}"
          @exec_options_title = 'Available options: '

          @exept_default_msg = "#{Most::UNIX_NAME} system: an exception occured";

          if config_io_stream
            mark_for_serialization(:exec_welcome_msg,   :exec_end_msg)
            mark_for_serialization(:exec_redef_err_msg, :exec_incorrect_path_msg)
            mark_for_serialization(:exec_usage_msg,     :exec_options_title)
            mark_for_serialization(:exept_default_msg)

            partially_deserialize(config_io_stream, Most::FORMAT)
          end
        end
      end

    end
  end
end