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
require 'optparse'

module Most

  class Starter
    CLI_OPTIONS =
      {:submission_flag =>
         ['-s', '--submission PATH', "Specifies the submission file"],
       :submission_parameters_flag =>
         ['-p', '--parameters value[ value]', "Specifies parameters for the submission"],
       :output_file_flag =>
         ['-f', '--file PATH', "Specifies the file where to output the report"],
       :version_flag =>
         ['-v', '--version', 'Displays version information and exits.'],
       :help_flag =>
         ['-h', '--help', 'Displays this help message and exits.'],
       :quiet_flag =>
         ['-q', '--quiet', 'Starts in quiet mode.'],
       :verbose_flag =>
         ['-V', '--verbose', 'Starts in verbose mode (ignored in quiet mode).'],
       :debug_flag =>
         ['-d', '--debug', 'Starts in debug mode.']}

    def initialize()
      @environment = SERVICES[:environment]

      @options = @environment.options
      @modes   = @environment.modes
      @tasks   = @environment.tasks

      @parser = OptionParser.new()
    end

    def run()
      if options_parsed?()
        begin
          if @modes[:verbose]
            @environment.show_message("#{FULL_NAME} has started on #{Time.now}", true)
          end

          SERVICES[:executor].run()

          if @modes[:verbose]
            @environment.show_message("#{FULL_NAME} has finished all tasks on #{Time.now}", true)
          end
        rescue Exception => e
          @environment.log_error(e, 'Command line interface failure')
        end
      end

      Most::GLOBALS[:exit_code] || 0
    end

    def options()
      CLI_OPTIONS
    end

    private

    #noinspection RubyDuckType
    def options_parsed?()
      result = true

      begin
        parser_argument(:version_flag) { @tasks[:show_version] = true }
        parser_argument(:help_flag)    { @tasks[:show_help]    = true }

        parser_argument(:verbose_flag) do
          @modes[:verbose] = true if not @modes[:quiet]
        end
        parser_argument(:quiet_flag) do
          @modes[:quiet]   = true
          @modes[:verbose] = false
        end
        parser_argument(:debug_flag) do
          @modes[:debug] = true
        end

        parser_argument(:submission_flag) do |submission|
          @options[:submission] = submission
        end

        parser_argument(:submission_parameters_flag) do |parameters|
          @options[:submission_parameters] ||= []

          unless parameters.nil?
            parameters = parameters.split(',').map { |item| item.strip() }
            @options[:submission_parameters] += parameters
          end
        end

        parser_argument(:output_file_flag) do |file|
          @options[:output_file] = file
        end

        @parser.parse!(@environment.arguments)

      rescue Exception => e
        result = false; @environment.log_error(e, 'Failed to parse arguments')
      end

      result
    end

    def parser_argument(name, &block)
      argument_key = name.intern()

      definition = CLI_OPTIONS[argument_key]
      @parser.on(*definition, &block)
    end
  end

end