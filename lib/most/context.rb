#    Most - Modular Open Software Tester.
#    Copyright (C) 2009  Dmitrii Toksaitov
#
#    This file is part of Most.
#
#    Most is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Most is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Most. If not, see <http://www.gnu.org/licenses/>.

require 'most/di/container'

module Most
  DIRECTORIES = DI::Container.new do
    asset :user_base do
      path = File.expand_path(USER_BASE_DIRECTORY)

      Dir.mkdir(path) unless File.directory?(path)

      path
    end

    asset :submissions do
      paths = []

      paths << File.expand_path(File.join(File.dirname(__FILE__), 'submissions'))
      paths << File.expand_path(File.join(DIRECTORIES[:user_base], 'submissions'))

      Dir.mkdir(paths.last) unless File.directory?(paths.last) rescue nil

      paths
    end

    asset :tasks do
      paths = []

      paths << File.expand_path(File.join(File.dirname(__FILE__), 'tasks'))
      paths << File.expand_path(File.join(DIRECTORIES[:user_base], 'tasks'))

      Dir.mkdir(paths.last) unless File.directory?(paths.last) rescue nil

      paths
    end

    asset :vendors do
      path = File.expand_path(File.join(DIRECTORIES[:user_base], 'vendors'))

      Dir.mkdir(path) unless File.directory?(path) rescue nil

      result = path.nil? ? [] : path.to_a()
    end

    asset :temp do
      path = File.expand_path(File.join(DIRECTORIES[:user_base], 'temp'))

      Dir.mkdir(path) unless File.directory?(path) rescue nil

      result = path.nil? ? [] : path.to_a()
    end
  end

  FILES = DI::Container.new do
    asset :log do
      File.join(DIRECTORIES[:user_base], 'application.log')
    end

    asset :options do
      File.join(DIRECTORIES[:user_base], 'options.yml')
    end

    asset :modes do
      File.join(DIRECTORIES[:user_base], 'modes.yml')
    end
  end

  SERVICES = DI::Container.new do
    service :environment do
      on_creation do
        require 'most/environment'; Environment.instance()
      end

      interface :log_error do |instance, exception, message|
        instance.log_error(exception, message)
      end

      interface :log_warning do |instance, text|
        instance.log_warning(text)
      end

      interface :log_message do |instance, text|
        instance.log_message(text)
      end

      interface :show_message do |instance, text, is_log_data|
        instance.show_message(text, is_log_data)
      end

      interface :state do |instance, text|
        instance.state(text)
      end
    end

    service :starter do
      on_creation do
        require 'most/starter'; Starter.new()
      end

      interface :run do |instance|
        instance.run()
      end

      interface :usage do |instance|
        instance.options
      end
    end

    service :core do
      on_creation do
        require 'most/core'; Core.new()
      end

      interface :run do |instance|
        instance.run()
      end
    end

    service :executor do
      on_creation do
        require 'most/executor'; Executor.new()
      end

      interface :run do |instance|
        instance.run()
      end
    end

    service :logger do
      on_creation do
        require 'logger'

        logger = Logger.new(FILES[:log], 10, 1048576)

        logger.level = Logger::INFO

        logger
      end

      interface :error do |instance, message|
        instance.error(message)
      end

      interface :warn do |instance, message|
        instance.warn(message)
      end

      interface :info do |instance, message|
        instance.info(message)
      end
    end

    service :diff do
      on_creation do
        begin
          require('diff/lcs'); Diff::LCS
        rescue nil; end
      end

      interface :diff do |instance, first_sequence, second_sequence|
        instance.diff(first_sequence, second_sequence)
      end
    end

    service :open4 do
      on_creation do
        if RUBY_PLATFORM.downcase.include?("mswin")
          require 'win32/open3'; Open4
        else
          require 'open4'; Open4
        end
      end

      interface :popen4 do |instance, args, block|
        instance.popen4(*args, &block)
      end
    end

    service :process_table do
      on_creation do
        require 'sys/proctable'; Sys::ProcTable
      end

      interface :info do |instance, pid|
        result = instance.ps(pid)
      end

      interface :memory do |instance, pid|
        result = 0

        if RUBY_PLATFORM.downcase.include?("mswin")
          result = instance.ps(pid).working_set_size
        else
          result = instance.ps(pid).size
        end

        result
      end

      interface :virtual_memory do |instance, pid|
        result = 0

        if RUBY_PLATFORM.downcase.include?("mswin")
          result = instance.ps(pid).page_file_usage
        else
          result = instance.ps(pid).rss
        end

        result
      end
    end
  end

  PARAMETERS = DI::Container.new do
    asset :options, :file => FILES[:options] do
      {:submission => nil,
       :submission_parameters => [],
       :output_file => nil}
    end

    asset :modes, :file => FILES[:modes] do
      {:verbose => false,
       :quiet   => false,
       :debug   => false}
    end

    asset :tasks do
      {:show_version => false,
       :show_help    => false}
    end
  end
end