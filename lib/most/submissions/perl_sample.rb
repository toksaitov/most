submission do
  name 'Simple Perl Submission'

  entities :executable  => path('main.pl')

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Perl Runner'

        add_step Proc do
          timeout_with_specs specs[:time] do
            total_memory_out_with_specs specs[:memory] do
              rake_clean 'win:perl:run', entities[:executable], input
            end
          end
        end

      end
    end

  end
end