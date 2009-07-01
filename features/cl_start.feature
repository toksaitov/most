Feature: Starting the Most system from the command line

  As a user of the Most system
  I want to start the Most system using the CLI
  Being able to set a specific configuration file
  Being able to redefine general parameters of the configuration
  Being able to request help or get it if I a mistake was made with the CLI options specifications
  Being able to request general information about the application such as app. name, version, and copyright
  Being able to select quiet or verbose mode where the quiet mode being specified disables the verbose mode
  In the result I want to get a proper CLI respond with the considerations of the selected running mode

  Scenario: Request for help
    Given this project is active project folder
    When I run local executable "most" wth arguments "-h"
    Then I get the output equals to ""