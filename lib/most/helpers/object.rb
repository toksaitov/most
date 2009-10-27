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

class Object
  def valid?(item, *args, &block)
    result = item.nil? ? false : true

    if result
      args.each do |objects|
        unless objects
          result = false; break;
        end
      end

      yield block if block_given?
    end

    result
  end

  def first_valid(item, *items)
    result = item

    if result.nil?
      items.each do |object|
        unless object.nil?
          result = object; break
        end
      end
    end

    result
  end

  def try(method_name, *args, &block)
    send(method_name, *args, &block) if respond_to?(method_name, true)
  end

  unless method_defined? :intern
    define_method(:intern) do
      result = self

      unless is_a?(Symbol)
        result.to_s().intern()
      end

      result
    end
  end
end