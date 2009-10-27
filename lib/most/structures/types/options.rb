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

  module OptionsHelpers
    def create_options(*args, &block)
      Options.new(*args, &block)
    end
  end

  class Options < Hash
    def initialize(hash = nil)
      super(); replace(hash) unless hash.nil?
    end

    def [](key, *args)
      if key.is_a?(Array)
        args.unshift(*key[1..-1])
        key = key.first
      end

      result = super(key)

      args.each do |item|
        break if result.nil?
        result = result.try(:[], item)
      end

      result
    end

    def has_any?(*args)
      result = nil

      args.each do |item|
        if item.is_a?(Array)
          result = self[*item]
        else
          result = self[item]
        end

        break unless result.nil?
      end

      result
    end
  end

end