require File.expand_path(File.dirname(__FILE__)) + '/../../most_serializer'

module Most
  module Helpers
    module Values

      class MostSpecs
        MOST_EXEC_OPTIONS =
          {:version_flag   => ['-v', '--version',       'Display the version information, then exit.'],
           :help_flag      => ['-h', '--help',          'Display this help message and exit.'],
           :quiet_flag     => ['-q', '--quiet',         'Run in quiet mode without any CLI messages.'],
           :verbose_flag   => ['-V', '--verbose',       'Run in verbose mode (ignored if quiet mode is on).'],
           :config_flag    => ['-c', '--config [PATH]', 'Use specific configuration file.'],
           :parameter_flag => ['-p', '--parameter [PARAMETER:VALUE]', 'Redefine a configuration parameter.']}

        attr_reader :default_config_path, :default_logger_config_path
        attr_reader :default_lang_path,   :default_log_path

        def initialize(config_io_stream = nil)
          @default_config_path        = '~/.most/configs/main_config.yml'
          @default_logger_config_path = '~/.most/configs/logger_config.yml'

          @default_lang_path = '~/.most/langs/lang.yml'
          @default_log_path  = '~/.most/logs/most.log'

          if config_io_stream
            mark_for_serialization(:default_config_path, :default_logger_config_path)
            mark_for_serialization(:default_log_path,    :default_lang_path)

            partially_deserialize(config_io_stream, Most::FORMAT)
          end
        end
      end

    end
  end
end