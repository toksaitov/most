require 'logger'

require File.expand_path(File.dirname(__FILE__)) + '/../../most_module'

module Most
  module Modules

    class MostLogger < MostModule
      MODULE_EXEC_POLICY = :unimportant_exec

      MODULE_ROOT_DIR = self.class.to_s()

      MODULE_DIRS = {:config_dir => 'configs',
                     :logs_dir   => 'logs'}

      MODULE_CONFIG_FILE_NAME = "#{self.class.to_s()}_config"

      FILE_DEST_KEY   = '<file>'
      STDOUT_DEST_KEY = '<stdout>'

      STDOUT_ENV_TYPE_KEY = 'env'
      STDOUT_SYS_TYPE_KEY = 'sys'

      attr_reader :instances_defenition, :instances

      def initialize(env)
        super(env, MODULE_EXEC_POLICY,
                   MODULE_ROOT_DIR,
                   MODULE_DIRS,
                   MODULE_CONFIG_FILE_NAME)

        @instances_defenition = []; @instances = {}

        mark_for_serialization(:instances_defenition); deserialize()
      end

      def add_instance(dest_sym, dest_defenition, *args)
        if dest_sym.kind_of?(Symbol)
          log_io = form_log_io(dest_defenition)

          if log_io
            @instances_defenition[dest_sym] = dest_defenition
            @instances[dest_sym] = Logger.new(log_io, args)
          end
        end
      end

      def get_instance(instance_sym)
        result = nil

        if instance_sym.kind_of?(Symbol)
          result = @instances[instance_sym]
        end

        return result
      end

      def remove_instance(instance_sym)
        if instance_sym.kind_of?(Symbol)
          @instances_defenition.delete(instance_sym)
          @instances.delete(instance_sym)
        end
      end

      private
      def set_default_values()
        @instances_defenition =
          {:default_log => ["#{FILE_DEST_KEY}:#{UNIX_NAME}_main.log:'a+'", [10, 1024000]],
           :aux_log     => ["#{STDOUT_DEST_KEY}:#{STDOUT_ENV_TYPE_KEY}"]}

        @instances_defenition.each do |def_key, def_value|
          add_instance(def_key, def_value[0], def_value[1])
        end
      end

      def form_log_io(dest_defenition)
        result = nil

        if dest_defenition.kind_of?(String)
          chunks = dest_defenition.split(':')

          if dest_defenition.kind_of?(String)
            chunks = dest_defenition.split(':')

            if chunks and chunks.size >= 2
              destination = chunks[0]
              case destination
                when FILE_DEST_KEY
                  if chunks.size == 3 and chunks[1] and chunks[2]
                    result = get_log_ios(chunks[1], chunks[2])
                  end
                when STDOUT_DEST_KEY
                  case chunks[1]
                    when STDOUT_ENV_TYPE_KEY
                      result = @env.stdout
                    when STDOUT_SYS_TYPE_KEY
                      result = STDOUT
                  end
              end
            end
          end
        end

        return result
      end

      def get_log_ios(file_name, io_mode)
        result = nil

        abs_file_path = "#{inner_dir(:logs_dir)}/#{form_file_name(file_name)}"
        result = get_file_stream(abs_file_path, io_mode)

        return result
      end
    end

  end
end