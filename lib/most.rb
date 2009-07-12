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

$:.unshift(req_dir_name) unless
  $:.include?(req_dir_name) || $:.include?(File.expand_path(req_dir_name))

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
  EMAIL = "#{UNIX_NAME}.support@85.17.184.9"

  # The offical website of the application
  URL = "http://85.17.184.9/#{UNIX_NAME}"

  # The copyright of the application
  COPYRIGHT = "Copyright (C) 2009 #{AUTHOR}"

  # The path to the root data directory
  DATA_ROOT_DIR_PATH = '~/'

  # The name of the root data directory
  DATA_ROOT_DIR = ".#{UNIX_NAME}"

  # Names of the application data directories
  DIRS =
    {# The name of the directory where the configuration should be stored
     :config_dir  => 'configs',

     # The name of the directory for modules
     :modules_dir => 'modules',

     # The name of the directory for temporary data
     :temp_dir    => 'temp'}

  # The name of the main configuration file
  CONFIG_FILE_NAME = "#{UNIX_NAME}_config"
end