#require "bundler/gem_tasks"
require 'bundler/gem_helper'

Bundler::GemHelper.install_tasks :name => "mygem"

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => :spec
