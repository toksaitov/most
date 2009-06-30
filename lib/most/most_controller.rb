req_dir_name = File.dirname(__FILE__)
abs_dir_name = File.expand_path(req_dir_name)

require abs_dir_name + '/alterers/most_serializer'

require abs_dir_name + '/most_base'

module Most

  class MostController < MostBase
    def initialize(env)
      super(env)
      
    end
    
    def start_default_routine()
      # ToDo - default routine code
    end
  end

end