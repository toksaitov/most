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

require 'singleton'

module Most

  class Environment
    include Singleton

    attr_reader :arguments

    attr_reader :logger
    attr_reader :options, :modes, :tasks

    def initialize()
      @arguments = ARGV

      @logger  = SERVICES[:logger]

      @options = PARAMETERS[:options]
      @modes   = PARAMETERS[:modes]
      @tasks   = PARAMETERS[:tasks]
    end

    def log_error(exception, message)
      @logger.error(message)
      @logger.error(exception.message)

      unless @modes.nil?
        @logger.error(exception.backtrace) if @modes[:verbose] or
                                              @modes[:debug]
      end

      GLOBALS[:exit_code] = 1
    end

    def log_warning(text)
      @logger.warn(text)
    end

    def log_message(text)
      @logger.info(text)
    end

    def show_message(message, is_log_data = false)
      puts "#{message}"
      log_message(message) if is_log_data
    end
  end

end