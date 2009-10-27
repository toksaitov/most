submission do
  name 'Simple Lisp Submission'

  entities :executable  => path('main.lisp')

  options  :tests => {:report => {:differences => true, :time => true, :specs => true},
                      :steps  => {:break => {:unsuccessful => true}}}

  YAML.load_file('tests.yml').each_with_index do |specs, i|

    add_test TestCase do
      name "Test #{i + 1}"

      input  specs[:input]
      output specs[:output]

      runner TestRunner do
        name 'Lisp Runner'

        add_step Proc do
          timeout specs[:time] do
            total_memory_out specs[:memory] do
              rake_clean 'win:lisp:run', entities[:executable], input
            end
          end
        end

      end
    end

  end
end