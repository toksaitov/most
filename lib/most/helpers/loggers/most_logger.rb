require 'logger'

require File.expand_path(File.dirname(__FILE__)) + '/../../most_serializer'

module Most
  module Helpers
    module Loggers

      class MostLogger
        attr_reader :io_stream
        attr_reader :instance

        def initialize(config_io_stream, log_io_stream = nil)
          if log_io_stream
            @io_stream = log_io_stream
          else
            if config_io_stream
              mark_for_serialization(@io_stream); partially_deserialize(config_io_stream, Most::FORMAT)
            end
          end

          if !@io_stream
            @io_stream = File.new(File.expand_path(Most::SPECS.default_log_path), 'a+')
          end

          @instance = Logger.new(@io_stream)
        end
        
        def halt()
          if @io_stream
            @io_stream.flush()
            @io_stream.close()
          end
        end
      end

    end
  end
end