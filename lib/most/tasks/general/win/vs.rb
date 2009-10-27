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
  namespace :vs do

    task :find_vsvars do
      if not ENV['VS90COMNTOOLS'].nil?
        ENV['VSVARS'] = File.join(ENV['VS90COMNTOOLS'], 'vsvars32.bat')
      elsif ENV['VS80COMNTOOLS'].nil?
        ENV['VSVARS'] = File.join(ENV['VS80COMNTOOLS'], 'vsvars32.bat')
      else
        program_files_paths = [ENV['%PROGRAMW6432%'], ENV['%PROGRAMFILES(X86)%']]
        vs_home_paths = ['Microsoft Visual Studio 9.0', 'Microsoft Visual Studio 8']

        paths_tail = File.join('Common7', 'Tools', 'vsvars32.bat')

        paths = []
        vs_home_paths.each do |home|
          program_files_paths.each do |path|
            paths << File.join(path, home, paths_tail)
          end
        end

        paths.each do |path|
          if File.exist?(path)
            ENV['VSVARS'] = path; break;
          end
        end

      end
    end

  end
end
