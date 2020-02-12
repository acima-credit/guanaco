# frozen_string_literal: true

require_relative 'lib/guanaco/version'

Gem::Specification.new do |s|
  s.name    = 'guanaco'
  s.version = Guanaco::VERSION
  s.authors = ['Adrian Esteban Madrid']
  s.email   = ['aemadrid@gmail.com']

  s.platform = 'java'

  s.summary     = 'A Ratpack based web server for JRuby.'
  s.description = s.summary
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  s.license               = 'MIT'
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib', 'lib/jars']

  s.add_dependency 'jrjackson'
  s.add_dependency 'pry'

  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'jar-dependencies'
  s.add_development_dependency 'rubocop'

  s.requirements << 'jar org.slf4j, slf4j-api, 1.7.10'
  s.requirements << 'jar org.slf4j, slf4j-simple, 1.7.10'
  s.requirements << 'jar io.ratpack, ratpack-core, 1.7.5'
  s.requirements << 'jar io.ratpack, ratpack-test, 1.7.5'
end
