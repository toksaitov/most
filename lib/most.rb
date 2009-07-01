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

require abs_dir_name + '/most/helpers/loggers/most_logger'

require abs_dir_name + '/most/helpers/formats/yaml_format_provider'

require abs_dir_name + '/most/helpers/values/most_specs'
require abs_dir_name + '/most/helpers/values/most_lang'

require abs_dir_name + '/most/most_controller'

module Most
  # General information

  # The name of the application
  FULL_NAME = 'Most, the Core'

  # The unix name of the application
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

  # Mandatory preparations

  # Check wether the data directories exist and creation of them if the process failed
  if (!File.directory?(File.expand_path("~/#{DATA_ROOT_DIR}/")))
    Dir.mkdir(File.expand_path("~/#{DATA_ROOT_DIR}/"))
  end

  DIRS.each do |key, name|
    if (!File.directory?(File.expand_path("~/#{DATA_ROOT_DIR}/#{name}")))
      Dir.mkdir(File.expand_path("~/#{DATA_ROOT_DIR}/#{name}"))
    end
  end

  # General fields

  # The current default format of the configuration and other Most system files
  FORMAT = Most::Helpers::Formats::YAMLFormatProvider.new()

  # General data and specifications
  init_conf_file_path =
          File.expand_path("~/#{DATA_ROOT_DIR}/#{DIRS[:CONFIG_DIR]}/#{INIT_CONFIG_FILE_NAME}")

  if !File.exists?(init_conf_file_path)
    init_conf_file_stream = File.open(init_conf_file_path, 'w+')
  else
    init_conf_file_stream = File.open(init_conf_file_path, 'r')
  end

  SPECS = Most::Helpers::Values::MostSpecs.new(init_conf_file_stream)

  # General purpose strings
  langs_file_path = File.expand_path(SPECS.default_lang_path)

  if !File.exists?(langs_file_path)
    langs_file_stream = File.open(langs_file_path, 'w+')
  else
    langs_file_stream = File.open(langs_file_path, 'r')
  end

  LANG = Most::Helpers::Values::MostLang.new(langs_file_stream)

  # Logger used by the Most system
  logger_conf_file_path = File.expand_path(SPECS.default_logger_config_path)

  if !File.exists?(logger_conf_file_path)
    logger_conf_file_stream = File.open(logger_conf_file_path, 'w+')
  else
    logger_conf_file_stream = File.open(logger_conf_file_path, 'r')
  end

  LOGGER = Most::Helpers::Loggers::MostLogger.new(logger_conf_file_stream)

  #
  # Most.init -> a new instance of the +MostController+ class
  #
  #   The +init+ method must be used directly before
  #   any other methods if the the application is used as a library.
  #
  #   If an attempt to use the application is made without the proper
  #   initialization (that is made by this method) an exception will be raised.
  #
  #   Returns a new instance of the MostController class.
  #
  #   Throws an correspondent exception if the initialization failed.
  #
  #     Most.init #=> MostController.new
  #
  
  def self.init
    return MostController.new()
  end

  def self.halt
    init_conf_file_path = "~/#{DATA_ROOT_DIR}/#{DIRS[:CONFIG_DIR]}/#{INIT_CONFIG_FILE_NAME}"
    init_conf_file_stream = File.open(File.expand_path(init_conf_file_path), 'w')

    SPECS.partially_serialize(init_conf_file_stream, Most::FORMAT)

    langs_file_path = SPECS.default_lang_path
    langs_file_stream = File.open(File.expand_path(langs_file_path), 'w')

    LANG.partially_serialize(langs_file_stream, Most::FORMAT)

    logger_conf_file_path = SPECS.default_logger_config_path
    logger_conf_file_stream = File.open(File.expand_path(logger_conf_file_path), 'w')

    LOGGER.partially_serialize(logger_conf_file_stream, Most::FORMAT)
    LOGGER.halt()
  end
end