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

require 'stringio'

module Kernel
  def register_extension(options)
    Most::GLOBALS[:extensions] ||= {}
    Most::GLOBALS[:extensions].update(options) if options.is_a?(Hash)
  end

  def source_extension(file_name)
    File.extname(file_name)
  end

  def exec_extension(file_name)
    result = nil

    Most::GLOBALS[:extensions] ||= {}
    result = Most::GLOBALS[:extensions][source_extension(file_name)].try(:[], :executable)

    result || ''
  end

  def extension_namespace(identifier)
    result = nil

    Most::GLOBALS[:extensions] ||= {}
    result = Most::GLOBALS[:extensions][source_extension(identifier)].try(:[], :namespace) ||
             Most::GLOBALS[:extensions][identifier].try(:[], :namespace)
    
    result || ''
  end

  def fake_std()
    result = [StringIO.new(), StringIO.new()]

    $stdout = result.first()
    $stderr = result.last()

    yield if block_given?

    return result
  ensure
    $stdout = STDOUT
    $stderr = STDERR
  end
end
