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

require 'observer'

module Most
  module DI

    class Service
      include Observable

      attr_reader :definition

      def initialize(definition = default_definition())
        @definition = definition; state_update()
      end

      def [](key)
        @definition[key]
      end

      def []=(key, value)
        result = nil

        previous_value = @definition[key]
        result = @definition[key] = value

        state_update() if previous_value != value

        result
      end

      def nil?()
        @definition.nil?
      end

      private
      def state_update()
        changed(); notify_observers(@definition)
      end

      def default_definition()
        {:block => nil, :instance => nil, :interfaces => nil, :file => nil}
      end
    end

  end
end