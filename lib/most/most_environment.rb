base_dir_name = File.dirname(__FILE__)
base_dir      = File.expand_path(base_dir_name)

require base_dir + '/most/interfaces/most_finalizable'

require base_dir + '/most/helpers/utilities/most_replacer'
require base_dir + '/most/helpers/formats/most_format_factory'

require base_dir + '/most/helpers/loggers/most_logger'

require base_dir + '/most/helpers/values/most_specs'
require base_dir + '/most/helpers/values/most_lang'

require base_dir + '/most/most_controller'

module Most

  class MostEnvironment
    include MostFinalizable

    attr_reader :stdin, :stdout

    attr_reader :format, :specs, :lang

    attr_reader :replacer
    attr_reader :logger

    def initialize(stdin = STDIN, stdout = STDOUT)
      if stdin and stdout
        @stdin  = stdin
        @stdout = stdout
      else
        fail()
      end

      prepare_directories()

      @replacer = prepare_replacer()

      @format = Helpers::Formats::MostFormatFactory.get_format()
      if !@format
        fail()
      end

      @specs  = Helpers::Values::MostSpecs.new(self, get_init_config_stream('r'))
      @lang   = Helpers::Values::MostLang.new(self, get_lang_file_stream('r'))

      @logger = Helpers::Loggers::MostLogger.new(self, get_logger_config_stream('r'))
    end

    def finalize()
      @specs.finalize()
      @lang.finalize()
      @logger.finalize()
    end

    private
    def prepare_directories()
      main_data_root_path =
        File.expand_path("#{DATA_ROOT_DIR_PATH}/#{DATA_ROOT_DIR}")

      if !File.directory?(main_data_root_path)
        Dir.mkdir(main_data_root_path)
      end

      DIRS.each_index do |i|
        dir_full_path = "#{main_data_root_path}/#{DIRS[i]}"

        if !File.directory?(dir_full_path)
          Dir.mkdir(dir_full_path)
        end
      end
    end

    def get_init_config_stream(io_mode)
      init_conf_file_path  = "#{Most::DATA_ROOT_DIR_PATH}/#{Most::DATA_ROOT_DIR}/"
      init_conf_file_path += "#{Most::DIRS[:CONFIG_DIR]}/#{Most::INIT_CONFIG_FILE_NAME}"

      init_conf_file_path = File.expand_path(init_conf_file_path)

      return get_file_stream(init_conf_file_path, io_mode)
    end

    def get_lang_file_stream(io_mode)
      lang_file_path = File.expand_path(@specs.default_lang_path)

      return get_file_stream(lang_file_path, io_mode)
    end

    def get_logger_config_stream(io_mode)
      logger_conf_file_path = File.expand_path(@specs.default_logger_config_path)

      return get_file_stream(logger_conf_file_path, io_mode)
    end

    def get_file_stream(expanded_file_path, requested_io_mode)
      result = nil

      begin
        if !File.exist?(expanded_file_path)
          result = File.open(expanded_file_path, 'w+')
        else
          result = File.open(expanded_file_path, requested_io_mode)
        end
      end rescue

      return result
    end

    def prepare_replacer()
      rules_hash = {}

      Most.constants.each do |const_name|
        curr_constant = Most.const_get(const_name)
        if curr_constant.kind_of?(String)
          rules_hash["<#{const_name.downcase()}>"] = curr_constant
        end
      end

      DIRS.each do |dir_key, dir_name|
        rules_hash["<#{dir_key.to_s().downcase()}>"] = dir_name
      end

      result = Helpers::Utilities::MostReplacer.new(rules_hash)

      return result
    end
  end
end