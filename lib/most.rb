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

require 'rubygems'

partial_path = File.dirname(__FILE__)
full_path    = File.expand_path(partial_path)

$LOAD_PATH.unshift(partial_path) unless $LOAD_PATH.include?(partial_path) or
                                        $LOAD_PATH.include?(full_path)

require 'most/helpers/object'
require 'most/helpers/numeric'
require 'most/helpers/kernel'
require 'most/helpers/array'
require 'most/helpers/symbol'
require 'most/helpers/hash'

require 'most/interfaces/meta_programmable'

module Most
  FULL_NAME = 'Most, the Core'
  UNIX_NAME = 'most'
  VERSION   = '0.7.4'

  AUTHOR = 'Toksaitov Dmitrii Alexandrovich'

  EMAIL = "#{UNIX_NAME}.support@85.17.184.9"
  URL   = "http://85.17.184.9/#{UNIX_NAME}"

  COPYRIGHT = "Copyright (C) 2009 #{AUTHOR}"

  USER_BASE_DIRECTORY = ENV['MOST_USER_BASE'] || File.join('~', ".#{UNIX_NAME}")
  GLOBALS = {}
end

require 'most/context'