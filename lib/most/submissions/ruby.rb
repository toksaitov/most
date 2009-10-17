submission do
  name 'Simple Ruby Submission'

  entities :executable => path(parameters.first || 'main.rb')

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Ruby Runner'

        add_step Proc do

          timeouts specs[:time] do
            total_memory_outs specs[:memory] do

              rake_clean 'win:ruby:run', entities[:executable], input

            end
          end
          
        end

      end
    end

  end
end