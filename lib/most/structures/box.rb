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

require 'time'
require 'yaml'
require "rexml/document"
require 'timeout'
require 'fileutils'

require 'most/helpers/memory_out'

require 'most/structures/types/path'
require 'most/structures/types/options'
require 'most/structures/types/report'

module Most

  module BoxHelpers
    def rake(task_name, *args)
      require 'rake/clean'

      Rake::Task[task_name].reenable()
      Rake::Task[task_name].invoke(*args)
    end
    
    def rake_clean(task_name, *args)
      require 'rake/clean'

      Rake::Task[task_name].reenable()
      Rake::Task[task_name].invoke(*args)
    ensure
      Rake::Task['clean'].reenable()
      Rake::Task['clean'].invoke()
    end
  end

  class Box
    include MetaProgrammable

    include PathHelpers
    include OptionsHelpers

    include Timeout
    include MemoryOut
    include FileUtils

    include BoxHelpers

    def initialize(options  = Options.new(),
                   entities = {},
                   globals  = [],
                   input    = '', &block)

      @options  = options
      @entities = entities
      @globals  = globals
      @input    = input

      @result = {}

      instance_eval(&block) if block_given?
    end

    def run(step)
      SERVICES[:environment].state("#{6.w}Executing a test box #{object_id}")
      SERVICES[:environment].state("#{6.w}Step type: #{step.class}")

      result = Report.new("Box: #{object_id}")

      if @options[:tests/:report/:specs]
        result.specs = {:options  => @options,
                        :entities => @entities,
                        :globals  => @globals,
                        :input    => @input}
      end

      result << execute(step)
      
      SERVICES[:environment].state("#{6.w}|--> Finished.")

      result
    end

    private
    def timeout_with_specs(sec, klass = nil, &block)
      @result[:limits] ||= {}
      @result[:limits][:time_limit] = sec

      timeout(sec, klass, &block)
    end

    def memory_out_with_specs(bytes, pid = nil, precision = 0.1, klass = nil, &block)
      @result[:limits] ||= {}
      @result[:limits][:memory_limit] = bytes

      memory_out(bytes, pid, precision, klass, &block)
    end

    def virtual_memory_out_with_specs(bytes, pid = nil, precision = 0.1, klass = nil, &block)
      @result[:limits] ||= {}
      @result[:limits][:virtual_memory_limit] = bytes

      virtual_memory_out(bytes, pid, precision, klass, &block)
    end

    def total_memory_out_with_specs(bytes, pid = nil, precision = 0.1, klass = nil, &block)
      @result[:limits] ||= {}
      @result[:limits][:total_memory_limit] = bytes

      total_memory_out(bytes, pid, precision, klass, &block)
    end

    def execute(step)
      @result[:started] = Time.now
      @result[:success] = true

      time = nil

      begin
        case step
          when ::String
            @result[:type] = String.to_s()
            time = process_string(step)
          when ::Proc
            @result[:type] = Proc.to_s()
            time = process_proc(step)
          when ::Class
            @result[:type] = step.class.to_s()
            time = process_class(step)
          else
            raise(TypeError, "Invalid type '#{step.class}' of the step")
        end
      rescue Exception => e
        @result[:success] = false
        @result[:error]   = e
      end

      check_environment()
      stop_created_process()
      clean_globals()

      if @options[:tests/:report/:time]
        @result[:time] = time unless time.nil?
      end

      @result
    end

    def process_string(step)
      time = benchmark do
        stdout, stderr = fake_std do
          instance_eval(&step)
        end
        report_std_streams(stdout, stderr)
      end

      time
    end

    def process_proc(step)
      time = benchmark do
        stdout, stderr = fake_std do
          instance_eval(&step)
        end
        report_std_streams(stdout, stderr)
      end

      time
    end

    def process_class(step)
      time = nil

      if step.respond_to?(:run)
        time = benchmark do
          stdout, stderr = fake_std do
            @result[:output] = step.new().run(self)
          end
          report_std_streams(stdout, stderr)
        end
      else
        raise(TypeError, "The '#{step.class}' do not have an appropriate interface")
      end

      time
    end

    def report_std_streams(stdout, stderr)
      @result[:step_stdout] = stdout.string unless stdout.nil?
      @result[:step_stderr] = stderr.string unless stderr.nil?
    end

    def check_environment()
      output = GLOBALS[:output]
      memory = GLOBALS[:memory]

      @result[:process_stdout] = output unless output.nil?
      @result[:memory_consumption] = memory unless memory.nil?
    end

    def stop_created_process()
      pid = GLOBALS[:pid]
      Process.kill('KILL', pid) unless pid.nil? rescue nil
    end

    def clean_globals()
      GLOBALS[:output] = nil
      GLOBALS[:memory] = nil
      GLOBALS[:pid]    = nil
    end

    def benchmark(&block)
      start_time = Time.now
      instance_eval(&block)
      end_time   = Time.now

      end_time.to_f() - start_time.to_f()
    end
  end

end