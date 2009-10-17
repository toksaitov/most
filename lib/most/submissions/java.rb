submission do
  name 'Simple Java Submission'

  entities :source => path(parameters.first || 'Main.java'),
           :executable => path((parameters.first || 'Main').to_extension('.class'))

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  rm entities[:executable], :force => true
  
  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Java Runner'

        add_step Proc do
          rake_clean 'win:java:compile', entities[:source], 
                                         entities[:executable]
        end

        add_step Proc do
          
          timeouts specs[:time] do
            total_memory_outs specs[:memory] do
              
              rake_clean 'win:java:run', entities[:executable], input
              
            end
          end
          
        end

      end
    end

  end
end