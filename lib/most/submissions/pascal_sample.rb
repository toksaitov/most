submission do
  name 'Simple Pascal Submission'

  entities :source_file => path('main.pas'), :executable => path('main.exe')

  options  :tests => {:report => {:differences => true, :time => true, :specs => true},
                      :steps  => {:break => {:unsuccessful => true}}}

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Pascal Runner'

        add_step Proc do
          rake_clean 'win:pascal:compile', entities[:source_file]
        end

        add_step Proc do
          timeout specs[:time] do
            total_memory_out specs[:memory] do
              rake_clean 'win:pascal:run', entities[:executable], input
            end
          end
        end

      end
    end

  end
end