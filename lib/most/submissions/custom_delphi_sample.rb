submission do
  specs = REXML::Document.new(File.new('problem.xml')).elements['problem/judging/script/testset']

  problem_name = Dir.pwd().split(/[\\|\/]/).last()

  number_of_tests = specs.attributes['test-count'].to_i()

  input_files = Dir[specs.attributes['input-href'].gsub('#', '[0-9]').chomp('.')]
  answer_files = Dir[specs.attributes['answer-href'].gsub('#', '[0-9]').chomp('.')]
  
  input_file = specs.attributes['input-name']
  output_file = specs.attributes['output-name']

  time_limit = specs.attributes['time-limit'].downcase
  if time_limit['ms']
    time_limit = time_limit.gsub('ms', '').to_i().milliseconds
  elsif time_limit['s']
    time_limit = time_limit.gsub('s', '').to_i()
  elsif time_limit['m']
    time_limit = time_limit.gsub('m', '').to_i().minutes
  elsif time_limit['m']
    time_limit = time_limit.gsub('h', '').to_i().hours
  end

  memory_limit = specs.attributes['memory-limit'].to_i()

  name "Custom Borland Delphi Submission: #{problem_name}"
  
  entities :problem_name => problem_name,

           :checker => path('check.dpr'), :checker_executable => path('check.exe'),
           :source  => path("#{problem_name}_is.dpr"), :executable => path("#{problem_name}_is.exe"),

           :input_file  => path(input_file),
           :output_file => path(output_file),
           :answer_file => path("#{problem_name}.a"),

           :result_file => path('result.xml'),

           :input_files  => input_files,
           :answer_files => answer_files

  options  :tests => {:report => {:differences => true, :time => true, :specs => false},
                      :steps  => {:break => {:unsuccessful => true}}}

  entities = entities()

  1.upto(number_of_tests) do |i|
    
    add_test TestCase do
      name "Test #{i}"

      input  path(entities[:input_file])
      output 'testlib: accepted'

      output_destination entities[:result_file]

      output_preprocessor Proc do |text|
        'testlib: ' + REXML::Document.new(text).elements['result'].
                                                attributes['outcome'].
                                                strip().
                                                downcase() rescue text
      end

      runner TestRunner do
        name 'Custom Borland Delphi Runner'

        add_step Proc do
          rake_clean 'win:borland_delphi:compile', entities[:checker]
        end

        add_step Proc do
          rake_clean 'win:borland_delphi:compile', entities[:source]
        end

        add_step Proc do
          rake_clean 'win:borland_delphi:compile', entities[:source]
        end

        add_step Proc do
          if entities[:input_files].size  != number_of_tests or
             entities[:answer_files].size != number_of_tests
            STDOUT.puts 'buba'

            rake 'win:run', 'cd tests && make'

            entities[:input_files]  = Dir[specs.attributes['input-href'].gsub('#', '[0-9]').chomp('.')]
            entities[:answer_files] = Dir[specs.attributes['answer-href'].gsub('#', '[0-9]').chomp('.')]
          end
        end

        add_step Proc do
          cp entities[:input_files][i - 1], File.join(Dir.pwd, entities[:input_file])
          cp entities[:answer_files][i - 1], File.join(Dir.pwd, entities[:answer_file])
        end

        add_step Proc do
          timeout_with_specs time_limit do
            total_memory_out_with_specs memory_limit do
              rake_clean 'win:borland_delphi:run', entities[:executable], input
            end
          end
        end

        add_step Proc do
          rake 'win:run', entities[:checker_executable],
               "#{entities[:input_file]} "  +
               "#{entities[:output_file]} " +
               "#{entities[:answer_file]} #{entities[:result_file]} -xml"

          rm [entities[:input_file],
              entities[:output_file],
              entities[:answer_file]], :force => true
        end
      end
    end

  end
end