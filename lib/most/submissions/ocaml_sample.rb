submission do
  name 'Simple OCaml Submission'

  entities :source_file => path('main.ml'), :executable => path('main.exe')

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'OCaml Runner'

        add_step Proc do
          rake_clean 'win:ocaml:compile', entities[:source_file], entities[:executable]
        end

        add_step Proc do
          timeout_with_specs specs[:time] do
            total_memory_out_with_specs specs[:memory] do
              rake_clean 'win:ocaml:run', entities[:executable], input
            end
          end
        end

      end
    end

  end
end