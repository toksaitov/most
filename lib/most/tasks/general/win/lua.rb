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
  namespace :lua do

    task :prepare do
      lua_home = nil
      Most::DIRECTORIES[:vendors].each do |directory|
        possible_path = File.join(directory, 'lua')
        lua_home = possible_path if File.directory?(possible_path)
      end

      unless lua_home.nil?
        clibs_path = File.join(lua_home, 'clibs')

        ENV['PATH'] ||= ''; ENV['PATH'] = "#{lua_home};#{clibs_path};#{ENV['PATH']}"

        ENV['LUA_DEV']   = lua_home
        ENV['LUA_PATH']  = ';;%LUA_DEV%\lua\?.luac'
        ENV['LUA_MPATH'] = '?.mlua;%LUA_DEV%\lua\metalua\?.mlua'
      end
    end

    task :compile, :source, :executable, :needs => [:prepare] do |task, args|
      compilation_command = %{luac -o #{args.executable} #{args.source}}

      service = Most::SERVICES[:open4]
      service.popen4(compilation_command) do |stdin, stdout, stderr, pid|
        $stdout.puts(stdout.read())
        $stderr.puts(stderr.read())
      end
    end

    task :run, :executable, :input do |task, args|
      args.with_defaults(:input => '')

      service = Most::SERVICES[:open4]
      service.popen4(%{lua #{args.executable}}) do |stdin, stdout, stderr, pid|
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