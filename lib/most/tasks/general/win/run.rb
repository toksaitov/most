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

require 'rake/clean'

namespace :win do

  task :run, :executable, :arguments do |task, args|
    args.with_defaults(:arguments => '')

    service = Most::SERVICES[:open4]
    service.popen4(%{#{args.executable} #{args.arguments}}) do |stdin, stdout, stderr, pid|
      Most::GLOBALS[:pid] = pid

      unless args.input.is_a?(Most::Path)
        stdin.write(args.input)
        stdin.close()
      end

      process_stdout = stdout.read()
      process_stderr = stderr.read()

      Most::GLOBALS[:output] = process_stdout

      $stdout.puts(process_stdout)
      $stderr.puts(process_stderr)
    end
  end

end