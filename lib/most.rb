$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "require_all"
require_all File.dirname(__FILE__) + '/most'

=begin

  Most is a simple academic modular open software tester.

  Most [Core] is the main part of the system. Most provides
  the environment and interface bridges for modules that will
  implement the basic functionality of the testing system.

  In general Most [Core] consists form two main interfaces:
  the connector and the tester.

  The connector interface offers the basic bridge to make
  an implementation of a module which will act as a controlling
  interface of the system. It can be a command line interface or
  it can be a module which will set up a server providing a network
  access for end users.

  The tester interface allows building an implementation of
  the software validator. By default the Most [Core] ships with
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
module Most
  # General information

  # The name of the application
  FULL_NAME = 'Most [Core]'

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

  #
  # Most.init -> a new instance of the MostController class
  #
  #   The <code>init</code> method must be used directly before
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
    return MostCroller.new
  end
end