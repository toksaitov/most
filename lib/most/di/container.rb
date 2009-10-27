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

require 'most/di/proxy'
require 'most/di/service_factory'

module Most
  module DI

    class Container
      class TrapError < Exception; end

      attr_reader :services

      def initialize(&block)
        @services = {}
        @current_service = nil

        instance_eval(&block) if block_given?
      end

      def service(name, &block)
        @current_service = name

        instance_eval(&block) if block_given?

        @current_service = nil
      end

      def on_creation(&block)
        asset(@current_service, &block)
      end

      def asset(name, options = {}, &block)
        instance = nil

        path = options[:file]
        unless path.nil?
          instance = YAML.load_file(File.expand_path(path)) rescue nil
        end

        if block_given? or not instance.nil?
          service = get_service(name)

          service[:block]    = block
          service[:instance] = instance
          service[:file]     = path
        end
      end

      def interface(name, service_name = nil, &block)
        service_name = @current_service if service_name.nil?

        if block_given?
          service = get_service(service_name)
          service[:interfaces][name.intern()] = block unless service.nil?
        end
      end

      def [](name)
        result = nil

        name = name.intern()
        service = @services[name]

        unless service.nil?
          result = service[:instance]
          if result.nil?
            instance = service[:block].call()
            unless instance.nil?
              result = service[:instance] = Proxy.new(instance, service[:interfaces])
            end
          end
        end

        result
      end

      def serialize_marked()
        @services.each do |key, service|
          serialize(service)
        end
      end

      def update(service)
        serialize(service) if service[:file]
      end

      private
      def serialize(service)
        path     = service[:file]
        instance = service[:instance]

        unless path.nil? and instance.nil?
          begin
            file = File.open(File.expand_path(path), 'w+')
            file.write(instance.to_yaml())
          rescue Exception => e
            puts "DI container failed to serialize service to #{path}"
            puts e.message, e.backtrace
          ensure
            file.close() unless file.nil?
          end
        end
      end

      def get_service(name)
        result = nil

        unless name.nil?
          name = name.intern()

          result = @services[name]
          if result.nil?
            new_service = DummyServiceFactory.get_service()
            new_service.add_observer(self)

            result = @services[name] = new_service
          end
        end

        result
      end

      def teardown()
        serialize_marked()
      end
    end

  end
end