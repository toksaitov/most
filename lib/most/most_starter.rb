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

require 'optparse'
require 'ostruct'

require 'rdoc/usage'

require 'date'

require 'helpers/most_serializable'

require 'helpers/most_values'

module Most
  class MostStarter < MostSerializable
    attr_reader :stdin, :stdout, :arguments

    attr_reader :options

    attr_reader :config

    def initialize(stdin = STDIN, stdout = STDOUT, arguments = [])
      super(nil, nil)

      @stdin  = stdin
      @stdout = stdout

      @arguments = arguments

      @options = OpenStruct.new()
      @options.show_version = false
      @options.show_help = false
      @options.verbose = false
      @options.quiet = false

      @config = OpenStruct.new(); serializable(@config); deserialize()
      @config.worker_name = "#{UNIX_NAME} #{DateTime.now().hash}" if @config.worker_name.nil?
    end

    def execute()
      if options_parsed?
        process_arguments()

        welcome_message = MostValues.MostStrings.MostExecution.WELCOME_MESSAGE
        @stdout.puts "#{welcome_message} on #{DateTime.now}." if @options.verbose

        init.start_default_routine()

        end_message = MostValues.MostStrings.MostExecution.END_MESSAGE
        @stdout.puts "#{end_message} on #{DateTime.now}" if @options.verbose
      else
        output_version()
        output_options()
      end
    end

    private
    def options_parsed?()
      result = true

      parser = OptionParser.new()

      options_def = OPTIONS[:version_flag]
      parser.on(options_def[0], options_def[1], options_def[2]) { @options.show_version = true }

      options_def = OPTIONS[:help_flag]
      parser.on(options_def[0], options_def[1], options_def[2]) { @options.show_help = true }

      options_def = OPTIONS[:verbose_flag]
      parser.on(options_def[0], options_def[1], options_def[2]) { @options.verbose = true }

      options_def = OPTIONS[:quiet_flag]
      parser.on(options_def[0], options_def[1], options_def[2]) do
        @options.quiet = true; @options.verbose = false
      end

      options_def = OPTIONS[:parameter_flag]
      parser.on(options_def[0], options_def[1], options_def[2]) do |parameters|
        parts = parameters.split(':')
        if parts.length == 2 and parts[0] and parts[1]
          @options.redefine_parameters = true;
          @options.parameters_to_redefine << [parts[0].strip(), parts[1].strip()]
        else
          @stdout.puts
            MostValues.MostStrings.MostExecution.
                  REDEF_INCORRECT_MESSAGE.sub('<argument>', parameters).
                                          sub('<correct_pattern>', options_def[1]) if !@options.quiet
        end
      end

      options_def = OPTIONS[:config_flag]
      parser.on(options_def[0], options_def[1], options_def[2]) do |path|
        if File.exist?(path) and File.readable?(path)
          @options.reload_config = true;
          @options.config_path = path.strip()
        else
          @stdout.puts
            MostValues.MostStrings.MostExecution.
                  INCORRECT_PATH_MESSAGE.sub('<path>', path) if !@options.quiet
        end
      end

      parser.parse!(@arguments) rescue result = false

      return result
    end

    def process_arguments()
      # TO DO - place in local vars, etc
    end

    def output_help()
      RDoc::usage()
    end

    def output_usage()
      RDoc::usage('usage')
    end

    def output_version()
      puts "#{UNIX_NAME}: #{File.basename(__FILE__)} - #{VERSION}"
    end

    def output_options()
      puts MostValues.MostStrings.MostExecution.OPTIONS_LIST_TITLE_MESSAGE

      @options.marshal_dump.each do |name, value, description|
        puts "  #{name} = #{value}, #{description}"
      end
    end
  end 
end