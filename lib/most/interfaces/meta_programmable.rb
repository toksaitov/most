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

module MetaProgrammable
  def method_missing(name, *args, &block)
    result = nil

    name = '@' + name.to_s().strip()
    value_required = false

    if name[-1] == ?=
      name = name[0..-2]
      value_required = true
    end

    if instance_variable_defined?(name)
      if args.empty? and value_required
        raise(ArgumentError, "Wrong number of arguments (#{args.length} for 1)")
      end

      block_was_used = false
      if args.empty?
        result = instance_variable_get(name)
      else
        if args.size == 1
          if args.first.is_a?(Class) and block_given?
            block_was_used = true
            result = instance_variable_set(name, args.first.new(&block))
          else
            result = instance_variable_set(name, args.first)
          end
        else
          result = instance_variable_set(name, args)
        end
      end
    else
      raise(NameError, "Instance variable '#{name}' is not defined")
    end

    instance_eval(&block) if block_given? and not block_was_used
    
    result
  end
end