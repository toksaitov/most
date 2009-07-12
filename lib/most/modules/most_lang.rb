require File.expand_path(File.dirname(__FILE__)) + '/../../most_module'

module Most
  module Modules

    class MostLang < MostModule
      MODULE_EXEC_POLICY = :important_exec

      MODULE_ROOT_DIR = self.class.to_s()

      MODULE_DIRS = {:config_dir => 'configs',
                     :langs_dir  => 'langs'}

      MODULE_CONFIG_FILE_NAME = "#{self.class.to_s()}_config"

      attr_reader :lang_fields, :lang_file, :lang_ios

      str_attr_reader :exec_welcome_msg,      :exec_end_msg,            :exec_version_msg,
                      :exec_redef_err_msg,    :exec_incorrect_path_msg,
                      :exec_usage_msg,        :exec_options_title,
                      :exec_parse_failed_msg

      str_attr_reader :exept_default_msg, :exept_init_failed_msg

      def initialize(env)
        super(env, MODULE_EXEC_POLICY,
                   MODULE_ROOT_DIR,
                   MODULE_DIRS,
                   MODULE_CONFIG_FILE_NAME)

        @lang_fields = get_lang_fields()
        @lang_ios    = get_lang_ios()

        mark_for_serialization(:lang_file); deserialize()
      end

      def deserialize()
        super.deserialize()

        partially_deserialize(@lang_ios, @env.format) if @lang_ios
      end

      def serialize()
        super.serialize()

        if @lang_ios and @lang_fields
          partially_serialize(@lang_ios, @env.format, @lang_fields)
        end
      end

      private
      def set_default_values()
        @lang_file = 'default_lang'

        set_default_lang_values()
      end

      def set_default_lang_values()
        @exec_welcome_msg = "<full_name> <version> has started"
        @exec_end_msg     = "<full_name> <version> is about to exit"
        @exec_version_msg = "<full_name> (<unix_name>): <version>"

        @exec_redef_err_msg = 'Parameter redefinition syntax is incorrect. ' +
                              'The redefinition string was "<argument>" ' +
                              'The pattern must be "<correct_pattern>".'

        @exec_incorrect_path_msg = 'The specified path is not correct. ' +
                                   'The path was "<path>".'

        @exec_parse_failed_msg = "Failed to parse options"

        @exec_usage_msg     = "Usage: <unix_name> {[option] [parameter]}"
        @exec_options_title = 'Available options: '

        @exept_default_msg     = "<unix_name> system: an exception occured"
        @exept_init_failed_msg = "<unix_name> system: failed to initialize core modules"
      end

      def get_lang_fields()
        result = []

        instance_variables.each do |field_name|
          field = instance_variable_get("@#{field_name}")
          result << field_name if field.kind_of?(String)
        end

        return result
      end

      def get_lang_ios()
        result = nil

        abs_file_path = "#{inner_dir(:langs_dir)}/#{form_file_name(@lang_file)}"
        result = get_file_stream(abs_file_path, 'r+')

        return result
      end
    end

  end
end