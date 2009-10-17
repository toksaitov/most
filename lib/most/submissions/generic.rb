submission do
  name 'Generic Submission'

  source = parameters.first; fail 'Source was not specified' if source.nil?

  source_extension = source_extension(source)
  exec_extension   = exec_extension(source)
  
  entities :source     => path(source),
           :executable => path(source.to_extension(exec_extension))

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  rm entities[:executable], :force => true

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Generic Test Runner'

        add_step Proc do
          rake_clean "#{extension_namespace(source_extension)}:compile",
                      entities[:source], entities[:executable]
        end

        add_step Proc do

          timeouts specs[:time] do
            total_memory_outs specs[:memory] do

              rake_clean "#{extension_namespace(source_extension)}:run",
                          entities[:executable], input

            end
          end

        end

      end
    end

  end
end