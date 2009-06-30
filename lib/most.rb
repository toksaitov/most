=begin
  Most is a simple academic modular open software tester.

  Most is the main part of the system. Most provides
  the environment and interface bridges for modules that will
  implement the basic functionality of the testing system.

  In general Most consists form two main interfaces:
  the connector and the tester.

  The connector interface offers the basic bridge to make
  an implementation of a module which will act as a controlling
  interface of the system. It can be a command line interface or
  it can be a module which will set up a server providing a network
  access for end users.

  The tester interface allows building an implementation of
  the software validator. By default the Most ships with
  the tester compliant with the ICPC Validator Standard. The Most system
  proposes to implement a testing system following this standard, but
  it is not obligatory. The 3-rd party implementation can vary
  significantly considering the user preferences.

  It is possible to build other interface bridges using the abstract
  interface classes provided by the Most system to extend
  the functionality of the modules. For example the implementation of
  the connector interface in the form of the network server can build
  a tunnel interface bridge, so that developers can make implementations,
  for example, of a SSH tunnel in order to provide a secure connection
  with the testing system.

  The default system bundle is shipped with a number of basic interface
  implementations (modules). Please, consider to take a look on the realize notes
  for the list of supplied modules.
=end

req_dir_name = File.dirname(__FILE__)
abs_dir_name = File.expand_path(req_dir_name)

$:.unshift(req_dir_name) unless
  $:.include?(req_dir_name) || $:.include?(abs_dir_name)

require abs_dir_name + '/most/interfaces/most_haltable'
require abs_dir_name + '/most/interfaces/most_initializable'

require abs_dir_name + '/most/helpers/loggers/most_logger'

require abs_dir_name + '/most/helpers/utilities/most_replacer'

require abs_dir_name + '/most/helpers/formats/yaml_format_provider'

require abs_dir_name + '/most/helpers/values/most_specs'
require abs_dir_name + '/most/helpers/values/most_lang'

require abs_dir_name + '/most/most_controller'

module Most
  # General information

  # The name of the system
  FULL_NAME = 'Most, the Core'

  # The unix name of the system
  UNIX_NAME = 'most'

  # The application version (rational versioning policy)
  VERSION = '0.0.1'

  # The author of the application (name of the project leader or name of the compony)
  AUTHOR = 'Toksaitov Dmitriy Alexandrovich'

  # The support e-mail of the application
  EMAIL = 'most.support@85.17.184.9'

  # The offical website of the application
  URL = 'http://85.17.184.9/most'

  # The copyright of the application
  COPYRIGHT = "Copyright (C) 2009 #{AUTHOR}"

  # The path to the root data directory
  DATA_ROOT_DIR_PATH = '~/'

  # The name of the root data directory
  DATA_ROOT_DIR = '.most'

  # Name of the application data directories 
  DIRS =
    {# The name of the directory where the configuration should be stored
     :CONFIG_DIR => 'configs',

     # The name of the directory for language files
     :LANG_DIR   => 'langs',

     # The name of the directory for log files
     :LOGS_DIR   => 'logs',

     # The name of the directory for temporary data
     :TEMP_DIR  => 'temp'}

  # The name of the initialization configuration file
  INIT_CONFIG_FILE_NAME = 'init_config.yml'

  class MostEnv
    include MostInitializable
    include MostHaltable

    attr_reader :instance

    attr_reader :format, :specs, :lang

    attr_reader :replacer
    attr_reader :logger

    def init()
      if !@instance
        prepare_directories()

        @replacer = prepare_replacer()

        @format = Most::Helpers::Formats::YamlFormatProvider.new() if @replacer

        @specs  = Most::Helpers::Values::MostSpecs.new(self, get_init_config_stream('r')) if @format
        @lang   = Most::Helpers::Values::MostLang.new(self,  get_lang_file_stream('r'))   if @specs

        @logger = Most::Helpers::Loggers::MostLogger.new(self, get_logger_config_stream('r')) if @lang

        if @logger
          @instance = self
        end
      end

      return @instance
    end

    def halt()
      if @instance
        @specs.partially_serialize(get_init_config_stream('w'), @format)
        @lang.partially_serialize(get_lang_file_stream('w'),    @format)

        @logger.partially_serialize(get_logger_config_stream('w'), @format)
        @logger.halt()

        @instance = nil
      end
    end

    private
    def prepare_directories()
      main_data_root_path =
        File.expand_path("#{Most::DATA_ROOT_DIR_PATH}/#{Most::DATA_ROOT_DIR}/")

      if (!File.directory?(main_data_root_path))
        Dir.mkdir(main_data_root_path)
      end

      Most::DIRS.each do |dir_key, dir_name|
        dir_full_path =
          File.expand_path("#{Most::DATA_ROOT_DIR_PATH}/#{Most::DATA_ROOT_DIR}/#{dir_name}")

        if (!File.directory?(dir_full_path))
          Dir.mkdir(dir_full_path)
        end
      end
    end

    def get_init_config_stream(io_mode)
      init_conf_file_path  = "#{Most::DATA_ROOT_DIR_PATH}/#{Most::DATA_ROOT_DIR}/"
      init_conf_file_path += "#{Most::DIRS[:CONFIG_DIR]}/#{Most::INIT_CONFIG_FILE_NAME}"

      init_conf_file_path = File.expand_path(init_conf_file_path)

      return get_file_stream(init_conf_file_path, io_mode)
    end

    def get_lang_file_stream(io_mode)
      lang_file_path = File.expand_path(@specs.default_lang_path)

      return get_file_stream(lang_file_path, io_mode)
    end

    def get_logger_config_stream(io_mode)
      logger_conf_file_path = File.expand_path(@specs.default_logger_config_path)

      return get_file_stream(logger_conf_file_path, io_mode)
    end

    def get_file_stream(expanded_file_path, requested_io_mode)
      result = nil

      begin
        if !File.exists?(expanded_file_path)
          result = File.open(expanded_file_path, 'w+')
        else
          result = File.open(expanded_file_path, requested_io_mode)
        end
      end rescue

      return result
    end

    def prepare_replacer()
      rules_hash = {}

      Most.constants.each do |const_name|
        curr_constant = Most.const_get(const_name)
        if curr_constant.kind_of?(String)
          rules_hash["<#{const_name.downcase()}>"] = curr_constant
        end
      end

      Most::DIRS.each do |dir_key, dir_name|
        rules_hash["<#{dir_key.to_s().downcase()}>"] = dir_name
      end

      result = Most::Helpers::Utilities::MostReplacer.new(rules_hash)

      return result
    end
  end
end