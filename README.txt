= Most, the Core

== Description

Most is a simple academic modular open software tester.

Most, the Core is the main part of the system. Most provides
the environment and interface bridges for modules that will
implement the basic functionality of the testing system.

In general Most, the Core consists form two main interfaces:
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
implementations (modules). Please, consider taking a look on realize
notes for the list of supplied modules.

== Features:

* Test-agnostic cross-platform testing application and library
* Ruby domain specific language (DSL) interface for test specifications
* YAML support for test specs and test reports
* Support of 16 languages out of the box with the predefined Rake Task bundles for compilation and execution
* Bundled sample test specifications for each language, which can help you to write your own specs

== Requirements

* Ruby 1.8.6 or later

=== Extra Dependencies

* sys-proctable (version 0.9.0 or later)

* open4 (version 1.0.1 or later) for *nix operation systems
* win32-open3 (version 0.3.1 or later) for Windows 2000 or later operation systems

=== Extra Development Dependencies

* newgem (version 1.5.1 or later)

== Installation

=== Gem Installation

The preferred method of the Most installation is through
the Gem file. For this you will need to have RubyGems installed.
If you have it, then you can install the system in the following way:

    gem install most

Note that you must have the correspondent account privileges
on your system in order to use this commands.

For other software bundles (including links for the source code packages)
consider visiting the official page of the project.

* http://85.17.184.9/most

== Synopsis

Most can be used as a standalone command line application
or as a library.

=== Library Usage

To get access to the core interface of the system you need to access
the "Core" class by specifying its name to the "SERVICES" dependency injection (DI) container:

    require 'most'

    most_core = Most::SERVICES[:core]

This will return a reference to the new "Core" instance through which you can control the entire
testing system.

=== Configuration

The default path for the configuration files is the ".most" directory under
the system user's home folder.

=== Command Line Usage

The list of command line options can be obtained from the Most executable by one of the following calls:

    most -h
    most --help

== Development

=== Source Repositories

Most is currently hosted at RubyForge and GitHub.

The RubyForge page is
* http://rubyforge.org/projects/most

The github web page is
* http://github.com/tda/most

The public git clone URL is
* http://github.com/tda/most.git

== Additional Information

Author:: Toksaitov Dmitrii Alexandrovich <toksaitov.d@gmail.com>

Project web site:: http://85.17.184.9/most
Project forum:: http://groups.google.com/group/most-system

== License

(The GNU General Public License)

Most is a simple academic modular open software tester.
Copyright (C) 2009 Toksaitov Dmitrii Alexandrovich

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.