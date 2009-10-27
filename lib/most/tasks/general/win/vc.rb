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

CLEAN.include('*.obj')

namespace :win do
  namespace :vc do

    task :prepare do
      vc_home = nil
      Most::DIRECTORIES[:vendors].each do |directory|
        possible_path = File.join(directory, 'vc')
        vc_home = possible_path if File.directory?(possible_path)
      end

      unless vc_home.nil?
        bin_path     = File.join(vc_home, 'bin')
        include_path = File.join(vc_home, 'include')
        lib_path     = File.join(vc_home, 'lib')

        ENV['PATH']    ||= ''; ENV['PATH']    = "#{bin_path};#{ENV['PATH']}"
        ENV['INCLUDE'] ||= ''; ENV['INCLUDE'] = "#{include_path};#{ENV['INCLUDE']}"
        ENV['LIB']     ||= ''; ENV['LIB']     = "#{lib_path};#{ENV['LIB']}"
      end

      ENV['CL'] = '/EHsc'
    end

    task :compile, :source, :needs => [:prepare] do |task, args|
      compilation_command = %{cl /O2 #{args.source}}

      service = Most::SERVICES[:open4]
      service.popen4(compilation_command) do |stdin, stdout, stderr, pid|
        $stdout.puts(stdout.read())
        $stderr.puts(stderr.read())
      end
    end

    task :run, :executable, :input do |task, args|
      args.with_defaults(:input => '')

      service = Most::SERVICES[:open4]
      service.popen4(args.executable) do |stdin, stdout, stderr, pid|
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
end