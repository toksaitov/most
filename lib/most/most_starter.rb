=begin rdoc
= Most, the Core

== Description

This is the main execution part à the Most system.

== Examples

* To start the Most system

  most

In this case the application will try to use the default path to
the configuration file (usually located under the '.most' folder in
the home directory). The application will try to access, load and
parse the configuration file. If this operation would fail, the system
will try to revert to the default configuration making attempts
to create the default configuration file overwriting the old one.

* To start the Most system with a specific configuration file

  most --configuration "~/special_configuration.yml"

The Most system will try to use that configuration. If
the Most would fail, it will revert back to
the default configuration file path.

  * Note that the main configuration file of the Most
    system must be in the YAML format.

* To redefine a parameter from the general group of the configuration file

  most --parameter port:7070
  most --parameter port:7071 --parameter=name:"New Worker Process"

  * Only parameters from the general group of the configuration
    file can be redefined.

  * Only parameters without whitespaces in their
    names can be redefined.

Other examples:

  most -v
  most --help

== Usage

most {[option] [parameter]}

=== Options

* Display the version information, then exit

  -v, --version

* Display this help message and exit

  -h, --help

* Run in quite mode

  -q, --quiet

* Run in verbose mode (the option will be ignored if the 'quiet' mode is on)

  -V, --verbose

* Use specific configuration file

  -c, --config [PATH]

* Redefine a configuration parameter (no whitespace in the name of parameter are allowed)

  -p, --parameter [PARAMETER:VALUE]

== Copyright

Most is a simple academic modular open software tester.
Copyright (C) 2009 Toksaitov Dmitriy Alexandrovich

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses>.
=end

require File.expand_path(File.dirname(__FILE__) + "/../most")

require 'optparse'
require 'ostruct'

require 'date'

module Most

  class MostStarter
    attr_reader :env

    attr_reader :stdin, :stdout, :arguments

    attr_reader :tasks, :options

    def initialize(stdin = STDIN, stdout = STDOUT, arguments = [])
      @stdin  = stdin
      @stdout = stdout

      @arguments = arguments

      @tasks = OpenStruct.new()

      @tasks.show_version = false
      @tasks.show_help = false

      @options = OpenStruct.new()

      @options.config_file = nil
      @options.additional_parameters = []

      @options.verbose = false
      @options.quiet = false
    end

    def execute()
      @env = Most::MostEnv.new().init()

      if @env
        if options_parsed?()
          perform_tasks()

          welcome_message = @env.lang.exec_welcome_msg
          @stdout.puts("#{welcome_message}: #{DateTime.now}.") if @options.verbose

          # ToDo - main code

          end_message = @env.lang.exec_end_msg
          @stdout.puts("#{end_message}: #{DateTime.now}.") if @options.verbose
        end

        @env.halt()
      end
    end

    private
    def options_parsed?()
      result = true

      begin
        parser = OptionParser.new()

        options_def = @env.specs.class::MOST_EXEC_OPTIONS[:version_flag]
        parser.on(options_def[0], options_def[1], options_def[2]) { @tasks.show_version = true }

        options_def = @env.specs.class::MOST_EXEC_OPTIONS[:help_flag]
        parser.on(options_def[0], options_def[1], options_def[2]) { @tasks.show_help = true }

        options_def = @env.specs.class::MOST_EXEC_OPTIONS[:verbose_flag]
        parser.on(options_def[0], options_def[1], options_def[2]) do
          @options.verbose = true if !@options.quiet
        end

        options_def = @env.specs.class::MOST_EXEC_OPTIONS[:quiet_flag]
        parser.on(options_def[0], options_def[1], options_def[2]) do
          @options.quiet = true; @options.verbose = false
        end

        options_def = @env.specs.class::MOST_EXEC_OPTIONS[:parameter_flag]
        parser.on(options_def[0], options_def[1], options_def[2]) do |params|
          add_params(params)
        end

        options_def = @env.specs.class::MOST_EXEC_OPTIONS[:config_flag]
        parser.on(options_def[0], options_def[1], options_def[2]) do |path|
          change_config_path(path)
        end
        
        parser.parse!(@arguments)
      rescue Exception => e
        @stdout.puts("#{@env.lang.exec_parse_failed_msg}, #{e.message}") if !@options.quiet
        result = false
      end

      return result
    end

    def perform_tasks()
      if @tasks.show_version
        output_version(); exit(0)
      end
      if @tasks.show_help
        output_help(); exit(0)
      end
    end

    def output_help()
      @stdout.puts("#{@env.lang.exec_usage_msg}\n\n")
      output_options()
    end
    
    def output_version()
      @stdout.puts(@env.lang.exec_version_msg)
      @stdout.puts(Most::COPYRIGHT)
    end

    def output_options()
      @stdout.puts(@env.lang.exec_options_title)

      @env.specs.class::MOST_EXEC_OPTIONS.each do |name, options|
        @stdout.puts("\n\t#{options[2]}\n\t\t#{options[0]}, #{options[1]}")
      end
    end

    def add_params(params_string)
      parts = params_string.split(':')

      param = ''; value = ''
      if (parts.length == 2) and
         (param = parts[0].strip()).length() > 0 and
         (value = parts[1].strip()).length() > 0 then
        @options.additional_parameters << [param, value]
      else
        if !@options.quiet
          error_msg = @env.lang.exec_redef_err_msg
          error_msg = @env.replacer.process(error_msg, {'<argument>' => params_string})

          options_def = @env.specs.class::MOST_EXEC_OPTIONS[:parameter_flag][1]
          error_msg   = @env.replacer.process(error_msg, {'<correct_pattern>' => options_def})

          @stdout.puts(error_msg)
        end
      end
    end

    def change_config_path(path_string)
      path_string.strip!()

      if File.exist?(path_string) and File.readable?(path_string)
        @options.config_file = path_string
      else
        if !@options.quiet
          error_msg = @env.lang.exec_incorrect_path_msg
          error_msg = @env.replacer.process(error_msg, {'<path>' => path_string})

          @stdout.puts(error_msg)
        end
      end
    end
  end

end