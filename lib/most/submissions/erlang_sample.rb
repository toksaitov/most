submission do
  name 'Simple Erlang Submission'

  entities :source_file => path('main.erl'), :entry_function => path('main')

  options  :tests => {:report => {:differences => true, :time => true, :specs => true},
                      :steps  => {:break => {:unsuccessful => true}}}

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Erlang Runner'

        add_step Proc do
          rake_clean 'win:erlang:compile', entities[:source_file]
        end

        add_step Proc do
          timeout specs[:time] do
            total_memory_out specs[:memory] do
              rake_clean 'win:erlang:run', entities[:entry_function], input
            end
          end
        end

      end
    end

  end
end