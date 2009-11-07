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
require 'stringio'

require 'most/structures/types/path'
require 'most/structures/types/options'
require 'most/structures/types/report'

require 'most/structures/test_runner'

module Most

  module TestCaseHelpers
    def create_test_case(*args, &block)
      TestCase.new(*args, &block)
    end
  end

  class TestCase
    include MetaProgrammable

    include PathHelpers
    include OptionsHelpers
    include RunnerHelpers

    def initialize(name   = 'Anonymous Test Case',
                   input  = '',
                   output = '',
                   output_destination  = nil,
                   output_preprocessor = lambda { |data| data.to_s().strip() },
                   runner = TestRunner.new(),
                   &block)

      @name   = name
      @input  = input

      @output = output
      @output_destination  = output_destination
      @output_preprocessor = output_preprocessor

      @runner = runner

      instance_eval(&block) if block_given?
    end

    def run(options, entities)
      SERVICES[:environment].state("#{' ' * 2}Processing test case: #{@name}")

      result = Report.new("Test Case: #{@name}")

      if options[:tests/:report/:specs]
        result.specs = {:name => @name,
                        :correct_output => @output,
                        :output_destination => @output_destination,
                        :runner => @runner}
      end

      result << process(options, entities)

      correct_status = result.last.last[:correct]; correct_status ||= false
      message = "#{' ' * 2}|--> Test case '#{@name}' correct?: #{correct_status}"

      SERVICES[:environment].show_message(message)

      result
    end

    private
    def process(options, entities)
      result = @runner.run(options, entities, @input)

      result.last[:correct_output] = @output
      if result.last[:success]
        process_result!(result.last, options)
      end

      result
    end

    def process_result!(result, options)
      test_output = nil

      if @output_destination.is_a?(Path)
        test_output = File.read(@output_destination.expand_path()) rescue nil
      else
        test_output = result[:process_stdout]
      end

      unless @output_preprocessor.nil?
        test_output = @output_preprocessor.call(test_output)
      end

      result[:processed_output] = test_output

      is_correct = output_equal?(test_output, @output)
      result[:correct] = is_correct

      if not is_correct and options[:tests/:report/:differences]
        diffs = differences(test_output, @output)
        result[:differences] = diffs unless diffs.nil?
      end
      
      nil
    end

    def differences(first_sequence, second_sequence)
      result = nil

      valid? first_sequence, second_sequence do
        begin
          result = SERVICES[:diff].diff(first_sequence, second_sequence)
        rescue Exception => e
          SERVICES[:environment].log_error(e, "Failed to process with the 'diff' service")
        end
      end

      result
    end

    def output_equal?(output, correct_output)
      result = nil

      valid? output, correct_output do
        first_stream  = get_stream(output)
        second_stream = get_stream(correct_output)

        result = !first_stream.nil? and !second_stream.nil?

        while result and valid? first_stream, second_stream
          first_char  = first_stream.getc()
          second_char = second_stream.getc()

          result = first_char == second_char

          break if first_char.nil? or second_char.nil?
        end

        first_stream.try(:close)
        second_stream.try(:close)
      end

      result
    end

    def get_stream(data)
      result = nil

      case data
        when ::String
          result = StringIO.new(data, 'r')
        when Path
          result = File.open(data.expand_path(), 'r')
        else
          result.try(:close)

          exception = TypeError.new("Invalid type: #{data.class}")
          SERVICES[:environment].log_error(exception, 'Invalid data or reference type')
      end

      result
    end
  end

end