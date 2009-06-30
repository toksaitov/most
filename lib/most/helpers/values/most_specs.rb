req_dir_name = File.dirname(__FILE__)
abs_dir_name = File.expand_path(req_dir_name)

require abs_dir_name + '/../../most_base'

require abs_dir_name + '/../../alterers/most_serializer'

module Most
  module Helpers
    module Values

      class MostSpecs < MostBase
        MOST_EXEC_OPTIONS =
          {:version_flag   => ['-v', '--version',       'Display the version information, then exit.'],
           :help_flag      => ['-h', '--help',          'Display this help message and exit.'],
           :quiet_flag     => ['-q', '--quiet',         'Run in quiet mode without any CLI messages.'],
           :verbose_flag   => ['-V', '--verbose',       'Run in verbose mode (ignored if quiet mode is on).'],
           :config_flag    => ['-c', '--config [PATH]', 'Use specific configuration file.'],
           :parameter_flag => ['-p', '--parameter [PARAMETER:VALUE]', 'Redefine a configuration parameter.']}

        attr_reader :default_config_path, :default_logger_config_path
        attr_reader :default_lang_path,   :default_log_path

        def initialize(env, config_io_stream = nil)
          super(env)

          set_default_values()

          if config_io_stream
            mark_for_serialization(:default_config_path, :default_logger_config_path)
            mark_for_serialization(:default_log_path,    :default_lang_path)

            partially_deserialize(config_io_stream, @env.format)
          end
        end

        private
        def set_default_values()
          @default_config_path        = '~/.most/configs/main_config.yml'
          @default_logger_config_path = '~/.most/configs/logger_config.yml'

          @default_lang_path = '~/.most/langs/lang.yml'
          @default_log_path  = '~/.most/logs/most.log'
        end
      end

    end
  end
end