Feature: Initialization of the library

  As a user of the Most library in my project
  I want to initialize the Most library
  In the result i want to get a reference to a valid MostController instance

  If something went wrong during the initialization,
  I want to get an exception with he description of the problem

  Scenario: Initialize Most
    Given this project is active project folder
    When I invoke method "Most.init"
    Then I get a reference to a "MostController" or an "MostException"