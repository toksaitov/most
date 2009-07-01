require 'rubygems' unless ENV['NO_RUBYGEMS']

require 'rake'
require 'rake/clean'

require 'fileutils'

require 'newgem'
require 'rubigen'

require File.dirname(__FILE__) + '/lib/most'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new(Most::UNIX_NAME, Most::VERSION) do |p|
  p.developer(Most::AUTHOR, Most::EMAIL)

  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.post_install_message = 'PostInstall.txt'

  p.rubyforge_name = p.name

  p.extra_deps = [
    ['activesupport','>= 2.0.2'],
  ]
  p.extra_dev_deps = [
    ['newgem', '>= 1.4.1']
  ]
  p.extra_dev_deps = [
    ['cucumber', '>= 0.3.11']
  ]

  p.clean_globs |= %w[**/.DS_Store tmp *.log]

  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  
  p.rsync_args = '-av --delete --ignore-errors'
end

# Load /tasks/*.rake
require 'newgem/tasks'
# Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# task :default => [:spec, :features]