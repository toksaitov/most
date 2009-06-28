require '../../most'

module Most
  class MostValues
    class MostStrings
      class MostExecution
        WELCOME_MESSAGE = "#{UNIX_NAME} #{VERSION} has started"
        END_MESSAGE     = "#{UNIX_NAME} #{VERSION} is about to exit"

        INCORRECT_REDEF_MESSAGE = 'Parameter redefinition syntax is incorrect. ' +
                                  'The redefenition string was <argument> ' +
                                  'The patter must be <correct_pattern>.'

        INCORRECT_PATH_MESSAGE = 'The specified path is not correct. ' +
                                 'The path was <path>.'

        OPTIONS_LIST_TITLE_MESSAGE = "Available options:\n"
      end

      class MostException
        DEFAULT_MESSAGE = 'An empty exception instance';
      end

      class MostSerializable
        DESR_RANGE_ERROR_MESSAGE = 'The number of the deserialized ' +
                                   'fields is not equal to the number ' +
                                   'of the field marked as serializable.'
      end
    end

    class MostSpecifications
      class MostExecution
        OPTIONS =
          {:version_flag   => ['-v', '--version',       'Display the version information, then exit.'],
           :help_flag      => ['-h', '--help',          'Display this help message and exit.'],
           :quiet_flag     => ['-q', '--quiet',         'Run in quiet mode without any CLI messages.'],
           :verbose_flag   => ['-V', '--verbose',       'Run in verbose mode (ignored if quiet mode is on).'],
           :config_flag    => ['-c', '--config [PATH]', 'Use specific configuration file.'],
           :parameter_flag => ['-p', '--parameter [PARAMETER:VALUE]', 'Redefine a configuration parameter.']}
      end
    end
  end
end