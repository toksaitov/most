base_dir = File.expand_path(File.dirname(__FILE__))

require base_dir + '/most_environment'

require base_dir + '/alterers/most_serializer'
require base_dir + '/alterers/most_str_attr'

require base_dir + '/interfaces/most_runnable'
require base_dir + '/interfaces/most_haltable'

module Most

  class MostModule
    include MostRunnable
    include MostFinalizable

    EXEC_POLICIES = [:unimportant_exec, :important_exec]

    attr_reader :env

    attr_reader :exec_policy

    attr_reader :config_ios

    attr_reader :dir_name,
                :dirs_list

    def initialize(most_environment, exec_policy   = nil,
                                     base_dir_name = nil,
                                     dirs_list     = nil,
                                     config        = nil)

      if exec_policy.kind_of?(Symbol) and EXEC_POLICIES[exec_policy]
        @policy = exec_policy
      else
        @policy = :unimportant_exec
      end

      if most_environment.kind_of?(MostEnvironment)
        @env = most_environment
      else
        fail()
      end

      @base_dir_name = base_dir_name
      @dirs_list     = dirs_list
      
      prepare_directories()

      if config.kind_of?(IO) and File.readable_real?(config)
        @config_ios = config
      elsif config.kind_of?(String)
        @config_ios = get_config_ios(config, 'r+')
      else
        @config_ios = nil
      end
    end

    def deserialize()
      set_default_values()
      partially_deserialize(@config_ios, @env.format) if @config_ios
    end

    def serialize()
      partially_serialize(@config_ios, @env.format) if @config_ios
    end

    def finalize()
      serialize()
    end

    protected
    def set_default_values()
    end

    def base_dir()
      return File.expand_path("#{DATA_ROOT_DIR_PATH}/#{DATA_ROOT_DIR}")
    end

    def modules_dir()
      return "#{base_dir}/#{DIRS[:modules_dir]}" 
    end

    def module_dir()
      result = nil

      result = "#{modules_dir}/#{@base_dir_name}" if @base_dir_name

      return result
    end

    def inner_dir(dir_name)
      result = nil

      if dir_name.kind_of?(Symbol)
        if @dirs_list and @dirs_list.has_key?(dir_name)
          result = "#{module_dir}/#{@dirs_list[dir_name]}"
        end
      elsif dir_name.kind_of?(String)
        result = "#{module_dir}/#{dir_name}"
      end 

      return result
    end

    def form_file_name(file_name)
      result = file_name

      if @env
        result = @env.format.format_extension(file_name)
      end

      return result
    end

    private
    def prepare_directories()
      if @base_dir_name.kind_of?(String)
        if !File.directory?(modules_dir)
          fail()
        end

        Dir.mkdir(module_dir) if !File.directory?(module_dir)

        @dirs_list.each_index do |i|
          if @dirs_list[i].kind_of?(String)
            dir_abs_path = inner_dir(@dirs_list[i])
            Dir.mkdir(dir_abs_path) if !File.directory?(dir_abs_path)
          end
        end if @dirs_list.kind_of?(Enumerable)
      end
    end

    def get_config_ios(config_file_name, io_mode)
      result = nil

      full_file_name = form_file_name(config_file_name)

      paths = []
      paths << "#{module_dir}/#{@dirs_list[:config_dir]}/#{full_file_name}"
      paths << "#{module_dir}/#{full_file_name}"
      paths << "#{base_dir}/#{DIRS[:config_dir]}/#{full_file_name}"

      paths.each do |abs_path|
        if File.exist?(abs_path) and File.readable_real?(abs_path)
          result = get_file_stream(abs_path, io_mode)
        end
        break if result
      end

      if !result
        if File.exist?(config_file_name) and File.readable_real?(config_file_name)
          result = get_file_stream(File.expand_path(config_file_name), io_mode)
        else
          result = get_file_stream(paths[0], io_mode)
        end
      end

      return result
    end

    def get_file_stream(abs_file_path, requested_io_mode)
      result = nil

      begin
        if File.exist?(abs_file_path)
          result = File.open(abs_file_path, requested_io_mode)
        else
          result = File.open(abs_file_path, 'w+')
        end
      end rescue

      return result
    end
  end

end