require File.expand_path(File.dirname(__FILE__)) + '/most_module'

module Most

  class ModuleFactory < MostModule
    MODULE_EXEC_POLICY = :important_exec

    MODULE_ROOT_DIR = self.class.to_s()

    MODULE_DIRS = {:config_dir => 'configs'}

    MODULE_CONFIG_FILE_NAME = "#{self.class.to_s()}_config"

    attr_reader :modules_dir, :modules_defenition

    def initialize(env)
      super(env, MODULE_EXEC_POLICY,
                 MODULE_ROOT_DIR,
                 MODULE_DIRS,
                 MODULE_CONFIG_FILE_NAME)

      @modules_defenition = []
      mark_for_serialization(:modules_defenition); deserialize()

      load_possible_modules()
    end

    def produce(instance)
      @modules_defenition.each do |defenition|
        if defenition and
                defenition.size == 2 and
                defenition[0] and defenition[1]
          instance_name = "@#{defenition[0].class.to_s().downcase()}"

          begin
            new_object = defenition[0].new(@env)
          rescue
            new_object = nil
          end

          if new_object
            instance.instance_variable_set(instance_name, new_object)
          end
        end
      end if instance and @modules_defenition
    end

    private
    def load_possible_modules()
      if @modules_dir
        abs_path = File.expand_path(@modules_dir)

        if File.directory?(abs_path)
          Dir["#{abs_path}/*.rb"].each { |file| require file }
        end
      end
    end

    def set_default_values()
      @modules_dir = 'modules'

      @modules_defenition = [[MostLogger, true],
                             [MostLang,   true]]
    end
  end

end