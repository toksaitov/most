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
  namespace :erlang do
    register_extension '.erl' => {:executable => '', :namespace => 'win:erlang'}
    
    task :prepare do
      erlang_home = nil
      Most::DIRECTORIES[:all_vendors].each do |directory|
        possible_path = File.join(directory, 'erlang')
        erlang_home = possible_path if File.directory?(possible_path)
      end

      unless erlang_home.nil?
        bin_path      = File.join(erlang_home, 'bin')
        erts_bin_path = File.join(erlang_home, 'erts', 'bin')

        ini_files = [File.join(bin_path, 'erl.ini').gsub(/[\/|\\]/, '\\' * 8),
                     File.join(erts_bin_path, 'erl.ini').gsub(/[\/|\\]/, '\\' * 8)]

        ENV['PATH'] ||= ''; ENV['PATH'] = "#{bin_path};#{ENV['PATH']}"

        ini_files.each do |path|
          File.open(path, 'w+') do |io|
            io.write "[erlang]\n" +
            "Bindir=#{erts_bin_path}\n" +
            "Progname=erl\n" +
            "Rootdir=#{erlang_home}\n"
          end rescue nil
        end
      end
    end

    task :compile, :source, :executable, :needs => [:prepare] do |task, args|
      args.with_defaults(:executable => nil)

      if args.executable.nil? or not File.exist?(args.executable)
        CLEAN.include('*.dump')

        compilation_command = %{erlc #{args.source}}

        service = Most::SERVICES[:open4]
        service.popen4(compilation_command) do |stdin, stdout, stderr, pid|
          $stdout.puts(stdout.read())
          $stderr.puts(stderr.read())
        end
      end
    end

    task :run, :entry_function, :input do |task, args|
      args.with_defaults(:entry_function => '', :input => '')

      service = Most::SERVICES[:open4]
      service.popen4(%{erl -noshell -run #{args.entry_function} -s init stop}) do |stdin, stdout, stderr, pid|
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