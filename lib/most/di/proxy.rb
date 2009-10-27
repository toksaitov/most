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

module Most
  module DI

    class Proxy
      instance_methods.each do |method|
        undef_method method unless method =~ /(^__|^send$|^object_id$)/
      end

      attr_reader :delegate, :interfaces

      def initialize(delegate, interfaces = {})
        @delegate   = delegate
        @interfaces = interfaces
      end

      private
      def method_missing(name, *args, &block)
        result = nil

        begin
          interface = @interfaces[name.intern()]
          unless interface.nil?
            args << block if block_given?
            result = interface.call(@delegate, *args)
          else
            result = @delegate.send(name, *args, &block)
          end
        rescue Exception => e
          raise(e, "delegate - #{@delegate.class}, method - #{name} #{args}")
        end

        result
      end
    end

  end
end