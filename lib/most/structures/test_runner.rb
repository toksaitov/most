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

require 'most/structures/box'

module Most

  module RunnerHelpers
    def create_test_runner(*args, &block)
      TestRunner.new(*args, &block)
    end
  end

  class TestRunner
    include MetaProgrammable

    include PathHelpers
    include OptionsHelpers

    def initialize(name = 'Anonymous Test Runner', steps = [], &block)
      @name  = name
      @steps = steps

      instance_eval(&block) if block_given?
    end

    def run(options, entities, input)
      SERVICES[:environment].state("#{' ' * 4}Processing test runner #{@name}")
      SERVICES[:environment].state("#{' ' * 4}Number of steps: #{@steps.size}")

      result = Report.new("Test Runner: #{@name}")

      if options[:tests/:report/:specs]
        result.specs = {:name  => @name,
                        :steps => @steps}
      end

      result << execute(options, entities, input)
      
      SERVICES[:environment].state("#{' ' * 4}|--> Test run successful?: #{result.last[:success]}")

      result
    end

    def add_step(step, &block)
      @steps ||= []
      if step.is_a?(Class) and block_given?
        @steps << step.new(&block)
      else
        @steps << step
      end
    end

    private
    def execute(options, entities, input)
      result = {:success => true,
                :steps => [],
                :process_stdout => nil}

      globals = {};
      @steps.each do |step|
        step_box = Box.new do
          options  options
          entities entities
          globals  globals
          input    input
        end

        step_result = step_box.run(step)
        globals     = step_box.globals

        result[:steps] << step_box
        result[:process_stdout] = step_result.last[:process_stdout]

        limits = step_result.last[:limits]

        unless limits.nil?
          result[:limits] ||= []
          result[:limits] << limits
        end

        unless step_result.last[:success]
          if options[:tests/:steps/:break/:unsuccessful]
            result[:success] = false
          end
        end

        break unless result[:success]
      end

      result
    end
  end

end