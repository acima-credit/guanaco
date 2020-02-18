# frozen_string_literal: true

require 'jars/installer'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'pathname'
require 'fileutils'

RAKE_ROOT = Pathname.new('.').dirname.expand_path

Bundler::GemHelper.install_tasks

desc 'Vendor jars'
task :vendor_jars do
  puts ' [ Vendor Jars ] '.center(120, '=')
  puts ' [ Remove ] '.center(120, '-')
  FileUtils.rm_rf RAKE_ROOT.join('lib', 'jars')
  puts ' [ Update ] '.center(120, '-')
  Jars::Installer.vendor_jars! 'lib/jars'
  puts ' [ Rubocop ] '.center(120, '-')
  Rake::Task['rubocop:auto_correct'].invoke
  puts ' [ Done! ] '.center(120, '=')
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |task|
    task.rspec_opts = [
      "-I#{RAKE_ROOT}",
      "-I#{RAKE_ROOT}/spec",
      '--color',
      '--format doc'
    ]
    task.rspec_opts << '--tag ~skip_ci' if ENV['CI'] == 'true'
    task.verbose = false
  end
  task default: :spec
rescue LoadError
  # No RSPEC for you!
end

begin
  require 'rubocop/rake_task'
  desc 'Runs rubocop with our custom settings'
  RuboCop::RakeTask.new(:rubocop) do |task|
    config = RAKE_ROOT.join('.rubocop.yml').to_s
    task.options = ['-D', '-c', config]
  end
rescue LoadError
  # Not loading rubocop tasks ...
end
