submission do
  name 'Simple Erlang Submission'

  entities :source => path(parameters.first || 'main.erl'),
           :executable => path((parameters.first || 'main').to_extension('.beam')),
           :entry_function => parameters.first || 'main'

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  rm entities[:executable], :force => true
  
  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Erlang Runner'

        add_step Proc do
          rake_clean 'win:erlang:compile', entities[:source],
                                           entities[:executable]
        end

        add_step Proc do

          timeouts specs[:time] do
            total_memory_outs specs[:memory] do

              rake_clean 'win:erlang:run', entities[:entry_function], input

            end
          end
          
        end

      end
    end

  end
end