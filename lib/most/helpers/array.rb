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

class Array
  def /(value)
    result = nil

    if value.is_a?(Symbol)
      result = self + [value]
    elsif value.is_a?(Array)
      result = self + value
    end

    result
  end

  alias old_method_missing method_missing
  def method_missing(name, *args, &block)
    result = nil
    
    numerals = ['first',   'second', 'third',
                'fourth',  'fifth',  'sixth',
                'seventh', 'eighth', 'ninth',
                'tenth']

    index = numerals.index(name.to_s())
    unless index.nil?
      result = self[index]
    else
      result = old_method_missing(name, *args, &block)
    end

    result
  end
end