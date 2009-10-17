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
  namespace :brainf do
    register_extension '.b' => {:namespace => 'win:brainf'}

    task :prepare do
      brainf_home = nil
      Most::DIRECTORIES[:all_vendors].each do |directory|
        possible_path = File.join(directory, 'brainf')
        brainf_home = possible_path if File.directory?(possible_path)
      end

      unless brainf_home.nil?
        ENV['PATH'] ||= ''; ENV['PATH'] = "#{brainf_home};#{ENV['PATH']}"
      end
    end

    task :run, :executable, :input, :needs => [:prepare] do |task, args|
      CLEAN.include('~app.b')
      CLEAN.include('*.out')

      input = args.input
      if args.input.is_a?(Most::Path)
        input = File.read(args.input)
      end

      source = File.read(args.executable)

      File.open('~app.b', 'w+') do |io|
        io.write("#{source}!#{input}")
      end

      IO.popen(%{bff4.exe <~app.b 1>~std.out 2>~err.out}, 'r') do |io|
        Most::GLOBALS[:pid] = io.pid
      end

      process_stdout = File.read('~std.out') rescue ''
      process_stderr = File.read('~err.out') rescue ''

      Most::GLOBALS[:output] = process_stdout

      $stdout.puts(process_stdout)
      $stderr.puts(process_stderr)
    end

  end
end