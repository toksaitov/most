# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{most}
  s.version = "0.7.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Toksaitov Dmitrii Alexandrovich"]
  s.date = %q{2009-10-30}
  s.default_executable = %q{most}
  s.description = %q{Most is a simple academic modular open software tester.



Most, the Core is the main part of the system. Most provides

the environment and interface bridges for modules that will

implement the basic functionality of the testing system.



In general Most, the Core consists form two main interfaces:

the connector and the tester.



The connector interface offers the basic bridge to make

an implementation of a module which will act as a controlling

interface of the system. It can be a command line interface or

it can be a module which will set up a server providing a network

access for end users.



The tester interface allows building an implementation of

the software validator. By default the Most ships with

the tester compliant with the ICPC Validator Standard. The Most system

proposes to implement a testing system following this standard, but

it is not obligatory. The 3-rd party implementation can vary

significantly considering the user preferences.



It is possible to build other interface bridges using the abstract

interface classes provided by the Most system to extend

the functionality of the modules. For example the implementation of

the connector interface in the form of the network server can build

a tunnel interface bridge, so that developers can make implementations,

for example, of a SSH tunnel in order to provide a secure connection

with the testing system.



The default system bundle is shipped with a number of basic interface

implementations (modules). Please, consider taking a look on realize

notes for the list of supplied modules.}
  s.email = ["most.support@85.17.184.9"]
  s.executables = ["most"]
  s.extra_rdoc_files = ["Copying.txt", "History.txt", "Manifest.txt", "PostInstall.txt", "README.txt"]
  s.files = ["Copying.txt", "History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "README.txt", "Rakefile", "bin/most", "lib/most.rb", "lib/most/context.rb", "lib/most/core.rb", "lib/most/di/container.rb", "lib/most/di/proxy.rb", "lib/most/di/service.rb", "lib/most/di/service_factory.rb", "lib/most/environment.rb", "lib/most/executor.rb", "lib/most/helpers/array.rb", "lib/most/helpers/hash.rb", "lib/most/helpers/kernel.rb", "lib/most/helpers/memory_out.rb", "lib/most/helpers/numeric.rb", "lib/most/helpers/object.rb", "lib/most/helpers/symbol.rb", "lib/most/interfaces/meta_programmable.rb", "lib/most/starter.rb", "lib/most/structures/box.rb", "lib/most/structures/submission.rb", "lib/most/structures/test_case.rb", "lib/most/structures/test_runner.rb", "lib/most/structures/types/options.rb", "lib/most/structures/types/path.rb", "lib/most/structures/types/report.rb", "lib/most/submissions/delphi.rb", "lib/most/submissions/brainf.rb", "lib/most/submissions/cpp_memory_out_sample.rb", "lib/most/submissions/cpp.rb", "lib/most/submissions/cpp_timeout_sample.rb", "lib/most/submissions/cs.rb", "lib/most/submissions/testlib.rb", "lib/most/submissions/erlang.rb", "lib/most/submissions/haskell.rb", "lib/most/submissions/java.rb", "lib/most/submissions/lisp.rb", "lib/most/submissions/lua.rb", "lib/most/submissions/ocaml.rb", "lib/most/submissions/pascal.rb", "lib/most/submissions/perl.rb", "lib/most/submissions/php.rb", "lib/most/submissions/python.rb", "lib/most/submissions/ruby.rb", "lib/most/submissions/vb.rb", "lib/most/tasks/general/win/delphi.rb", "lib/most/tasks/general/win/brainf.rb", "lib/most/tasks/general/win/cs.rb", "lib/most/tasks/general/win/erlang.rb", "lib/most/tasks/general/win/gcc.rb", "lib/most/tasks/general/win/haskell.rb", "lib/most/tasks/general/win/java.rb", "lib/most/tasks/general/win/lisp.rb", "lib/most/tasks/general/win/lua.rb", "lib/most/tasks/general/win/ocaml.rb", "lib/most/tasks/general/win/pascal.rb", "lib/most/tasks/general/win/perl.rb", "lib/most/tasks/general/win/php.rb", "lib/most/tasks/general/win/python.rb", "lib/most/tasks/general/win/ruby.rb", "lib/most/tasks/general/win/run.rb", "lib/most/tasks/general/win/vb.rb", "lib/most/tasks/general/win/vc.rb", "lib/most/tasks/general/win/vs.rb", "samples/testlib/ones/check.dpr", "samples/testlib/ones/ones_is.dpr", "samples/testlib/ones/ones_rs.dpr", "samples/testlib/ones/sum_of_numbers.xml", "samples/testlib/ones/tests/clean.bat", "samples/testlib/ones/tests/make.bat", "samples/testlib/ones/tests/make_answers.bat", "samples/testlib/ones/tests/ones_rs.exe", "samples/testlib/ones/tests/shuffle.dpr", "samples/testlib/ones/tests/shuffle.exe", "samples/testlib/ones/tests/tests.lst", "samples/sum_of_numbers/solutions/brainf/main.b", "samples/sum_of_numbers/solutions/brainf/tests.yml", "samples/sum_of_numbers/solutions/cpp/main.cpp", "samples/sum_of_numbers/solutions/cpp/tests.yml", "samples/sum_of_numbers/solutions/cs/main.cs", "samples/sum_of_numbers/solutions/cs/tests.yml", "samples/sum_of_numbers/solutions/delphi/main.dpr", "samples/sum_of_numbers/solutions/delphi/tests.yml", "samples/sum_of_numbers/solutions/erlang/main.erl", "samples/sum_of_numbers/solutions/erlang/tests.yml", "samples/sum_of_numbers/solutions/haskell/main.hs", "samples/sum_of_numbers/solutions/haskell/tests.yml", "samples/sum_of_numbers/solutions/java/Main.java", "samples/sum_of_numbers/solutions/java/tests.yml", "samples/sum_of_numbers/solutions/lisp/main.lisp", "samples/sum_of_numbers/solutions/lisp/tests.yml", "samples/sum_of_numbers/solutions/lua/main.lua", "samples/sum_of_numbers/solutions/lua/tests.yml", "samples/sum_of_numbers/solutions/ocaml/main.ml", "samples/sum_of_numbers/solutions/ocaml/tests.yml", "samples/sum_of_numbers/solutions/pascal/main.pas", "samples/sum_of_numbers/solutions/pascal/tests.yml", "samples/sum_of_numbers/solutions/perl/main.pl", "samples/sum_of_numbers/solutions/perl/tests.yml", "samples/sum_of_numbers/solutions/php/main.php", "samples/sum_of_numbers/solutions/php/tests.yml", "samples/sum_of_numbers/solutions/python/main.py", "samples/sum_of_numbers/solutions/python/tests.yml", "samples/sum_of_numbers/solutions/ruby/main.rb", "samples/sum_of_numbers/solutions/ruby/tests.yml", "samples/sum_of_numbers/solutions/vb/main.vb", "samples/sum_of_numbers/solutions/vb/tests.yml", "samples/time_and_memory_out/solutions/cpp/main.cpp", "samples/time_and_memory_out/solutions/cpp/tests.yml", "tasks/samples.rb"]
  s.post_install_message = %q{Thank you for installing the Most system

Please be sure to read Readme.rdoc and History.rdoc
for useful information about this release.

For more information on Most, see http:/85.17.184.9/most}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{most}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Most is a simple academic modular open software tester}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sys-proctable>, [">= 0.9.0"])
      s.add_development_dependency(%q<newgem>, [">= 1.5.1"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<sys-proctable>, [">= 0.9.0"])
      s.add_dependency(%q<newgem>, [">= 1.5.1"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<sys-proctable>, [">= 0.9.0"])
    s.add_dependency(%q<newgem>, [">= 1.5.1"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
