require 'logger'

req_dir_name = File.dirname(__FILE__)
abs_dir_name = File.expand_path(req_dir_name)

require abs_dir_name + '/../../most_base'

require abs_dir_name + '/../../alterers/most_serializer'

require abs_dir_name + '/../../interfaces/most_haltable'

module Most
  module Helpers
    module Loggers

      class MostLogger < MostBase
        include MostHaltable

        attr_reader :io_stream
        attr_reader :instance

        def initialize(env, config_io_stream, log_io_stream = nil)
          super(env)

          if log_io_stream
            @io_stream = log_io_stream
          else
            if config_io_stream
              mark_for_serialization(@io_stream); partially_deserialize(config_io_stream, @env.format)
            end
          end

          if !@io_stream
            @io_stream = File.new(File.expand_path(@env.specs.default_log_path), 'a+')
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