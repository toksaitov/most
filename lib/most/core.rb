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
require 'rake/clean'

require 'most/structures/submission'

module Most

  class Core
    class UnregisteredExtensionError < Exception; end

    def initialize()
      @environment = SERVICES[:environment]
      @options     = @environment.options

      @strategies  = register_strategies()

      @last_eval_result = nil

      load_objects()
    end

    def run()
      result = nil

      submission = @options[:submission]
      
      paths = form_paths(submission)
      extension = File.extname(submission)

      proc = @strategies[extension]
      unless proc.nil?
        result = proc.call(paths)
      else
        exception = UnregisteredExtensionError.new("#{extension} is not registered")
        @environment.log_error(exception, "Only 'rb' or 'yml' extensions are allowed")
      end

      result
    end

    private
    def form_paths(submission)
      paths = DIRECTORIES[:all_submissions].collect do |directory|
        File.expand_path(File.join(directory, submission))
      end

      paths << File.expand_path(submission)

      paths
    end
    
    def register_strategies()
      result = {}

      result['.yml'] = process_yaml_lambda()
      
      result['.rb']  = process_ruby_lambda()
      result['']     = process_ruby_lambda()

      result
    end

    def process_yaml_lambda()
      lambda do |paths|
        result = ''

        klass = nil; last_exception = nil
        paths.each do |path|
          begin
            klass = YAML.load_file(path)
          rescue LoadError => e
            last_exception = e; next
          rescue Exception => e
            last_exception = e
          end

          break
        end

        unless klass.nil?
          begin
            result = klass.run()
          rescue Exception => e
            @environment.log_error(e, 'Failed to execute submission')
          end
        else
          if last_exception.nil?
            exception = TypeError.new("Invalid submission type")
          else
            exception = last_exception
          end
          @environment.log_error(exception, 'Submission load or execution failure')
        end

        result
      end
    end

    def process_ruby_lambda()
      lambda do |paths|
        result = ''

        code = nil; exception = nil
        paths.each do |path|
          begin
            code = File.read(File.extname(path).empty? ? "#{path}.rb" : path)
          rescue Exception => e
            exception = e; next
          end

          break
        end

        unless code.nil?
          begin
            instance_eval(code); result = @last_eval_result
          rescue Exception => e
            @environment.log_error(e, 'Failed to execute submission')
          end
        else
          @environment.log_error(exception, 'Submission load or execution failure')
        end

        result
      end
    end

    def submission(*args, &block)
      @last_eval_result = Submission.new(*args, &block).run()
    end

    def load_objects()
      result = DIRECTORIES[:all_tasks]

      if result.is_a?(Array)
        result.each do |directory|
          load_from_directory(directory)
        end
      else
        load_from_directory(result)
      end
    end

    def load_from_directory(directory)
      Dir[File.join(directory, '**', '*.{rb,task,tasks}')].each do |file|
        begin
          require(file)
        rescue Exception => e
          @environment.log_error(e, 'Failed to load executor')
        end
      end
    end
  end

end