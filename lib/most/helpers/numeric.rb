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

class Numeric
  def milliseconds()
    self / 100.0
  end

  def seconds()
    self
  end

  def minutes()
    self * 60
  end

  def hours()
    self * 3600
  end

  def bits()
    self * 8
  end

  def bytes()
    self
  end

  def kilobytes()
    self * 1024
  end

  def megabytes()
    self * 1048576
  end

  def gigabytes()
    self * 1073741824
  end

  def petabytes()
    self * 1099511627776
  end
end