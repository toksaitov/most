req_dir_name = File.dirname(__FILE__)
abs_dir_name = File.expand_path(req_dir_name)

require abs_dir_name + '/../../most_base'

require abs_dir_name + '/../../alterers/most_serializer'
require abs_dir_name + '/../../alterers/most_str_processor'

module Most
  module Helpers
    module Values

      class MostLang < MostBase
        str_attr_reader :exec_welcome_msg,      :exec_end_msg,            :exec_version_msg
        str_attr_reader :exec_redef_err_msg,    :exec_incorrect_path_msg
        str_attr_reader :exec_usage_msg,        :exec_options_title
        str_attr_reader :exec_parse_failed_msg

        str_attr_reader :exept_default_msg, :exept_init_failed_msg

        def initialize(env, config_io_stream = nil)
          super(env);

          set_default_values()

          if config_io_stream
            mark_for_serialization(:exec_welcome_msg,        :exec_end_msg,
                                   :exec_version_msg,        :exec_redef_err_msg,
                                   :exec_incorrect_path_msg, :exec_usage_msg,
                                   :exec_options_title,      :exec_parse_failed_msg,
                                   :exept_default_msg,       :exept_init_failed_msg)

            partially_deserialize(config_io_stream, @env.format)
          end          
        end

        private
        def set_default_values()
          @exec_welcome_msg = "<full_name> <version> has started"
          @exec_end_msg     = "<full_name> <version> is about to exit"
          @exec_version_msg = "<full_name> (<unix_name>): <version>"

          @exec_redef_err_msg = 'Parameter redefinition syntax is incorrect. ' +
                                'The redefenition string was "<argument>" ' +
                                'The pattern must be "<correct_pattern>".'

          @exec_incorrect_path_msg = 'The specified path is not correct. ' +
                                     'The path was "<path>".'

          @exec_parse_failed_msg = "Failed to parse options"

          @exec_usage_msg     = "Usage: <unix_name> {[option] [parameter]}"
          @exec_options_title = 'Available options: '

          @exept_default_msg     = "<unix_name> system: an exception occured"
          @exept_init_failed_msg = "<unix_name> system: failed to initialize core modules"
        end
      end

    end
  end
end