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

require 'yaml'

module Most

  class Report
    attr_accessor :name, :specs
    
    def initialize(name = 'Untitled Report', specs = {})
      @name  = name
      @specs = specs
      
      @units = []
    end

    def add_entry(entry)
      @units << entry
    end
    alias << add_entry

    def get_entry(index)
      @units[index]
    end
    alias [] get_entry

    def set_entry(index, value)
      @units[index] = value
    end
    alias []= set_entry

    def delete_entry(entry)
      @units.delete(entry)
    end
    alias delete delete_entry

    def delete_entry_at(index)
      @units.delete_at(index)
    end
    alias delete_at delete_entry_at

    def first_entry()
      @units.first
    end
    alias first first_entry

    def first_entry=(entry)
      @units.first = entry
    end
    alias first= first_entry=

    def last_entry()
      @units.last
    end
    alias last last_entry

    def last_entry=(entry)
      @units.last = entry
    end
    alias last= last_entry=

    def to_s()
      to_yaml()
    end
    alias text to_s
  end

end