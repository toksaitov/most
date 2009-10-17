submission do
  name 'Simple OCaml Submission'

  entities :source => path(parameters.first || 'main.ml'),
           :executable => path((parameters.first || 'main').to_extension('.exe'))

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  rm entities[:executable], :force => true
  
  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'OCaml Runner'

        add_step Proc do
          rake_clean 'win:ocaml:compile', entities[:source], 
                                          entities[:executable]
        end

        add_step Proc do
          
          timeouts specs[:time] do
            total_memory_outs specs[:memory] do
              
              rake_clean 'win:ocaml:run', entities[:executable], input
              
            end
          end
          
        end

      end
    end

  end
end