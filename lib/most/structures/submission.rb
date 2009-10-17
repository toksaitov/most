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

require 'yaml'

require 'most/structures/types/path'
require 'most/structures/types/options'
require 'most/structures/types/report'

require 'most/structures/test_case'

module Most

  module SubmissionHelpers
    def create_submission(*args, &block)
      Submission.new(*args, &block)
    end
  end

  class Submission
    include MetaProgrammable

    include PathHelpers
    include OptionsHelpers
    include TestCaseHelpers

    def initialize(name     = 'Anonymous Submission',
                   tests    = [],
                   options  = Options.new(),
                   entities = {}, &block)

      @name       = name
      @tests      = tests
      @entities   = entities
      @parameters = SERVICES[:environment].
                      options[:submission_parameters]

      options(options)

      instance_eval(&block) if block_given?
    end

    def options(*args)
      result = nil

      if args.empty?
        @options ||= Options.new()
        result = @options
      else
        options = args.size == 1 ? args.first : args

        unless options.is_a?(Options)
          options = options.try(:to_options)
          if options.nil?
            options = Options.new()
          end
        end

        result = @options = options
      end

      result
    end

    def add_test(test, &block)
      @tests ||= []
      if test.is_a?(Class) and block_given?
        @tests << test.new(&block)
      else
        @tests << test
      end
    end

    def run()
      SERVICES[:environment].show_message("Working...")
      SERVICES[:environment].state("Processing submission #{@name}")
      SERVICES[:environment].state("Number of test cases: #{@tests.size}")

      result = Report.new("Submission: #{@name}")

      if @options[:tests/:report/:specs]
        result.specs = {:name  => @name,
                        :tests => @tests}
      end

      @tests.each do |test|
        result << test.run(@options, @entities)

        unless result.last.last.last[:success]
          break if @options[:tests/:break/:unsuccessful]
        end

        unless result.last.last.last[:correct]
          break if @options[:tests/:break/:incorrect]
        end
      end

      SERVICES[:environment].state("|--> Finished.")

      result.to_yaml()
    end
  end

end