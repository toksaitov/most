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

namespace :samples do

  desc "Copy sample solutions and tests to the base ('.most') temp directory"
  task :prepare do
    require 'fileutils'

    paths = [[File.join(MOST_ROOT, 'samples', 'problems', '.'), Most::DIRECTORIES[:problems]],
             [File.join(MOST_ROOT, 'samples', 'submissions', '.'), Most::DIRECTORIES[:user_submissions]]]

    paths.each do |pair|
      FileUtils.cp_r(pair.first, pair.last, :verbose => true)
    end
  end

end