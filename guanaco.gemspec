# frozen_string_literal: true

require_relative 'lib/guanaco/version'

Gem::Specification.new do |s|
  s.name    = 'guanaco'
  s.version = Guanaco::VERSION
  s.authors = ['Adrian Esteban Madrid']
  s.email   = ['aemadrid@gmail.com']

  s.platform = 'java'

  s.summary = 'A Ratpack based web server for JRuby.'
  s.description = s.summary
  s.homepage = "https://github.com/acima-credit/guanaco"
  s.license = 'MIT'
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  s.metadata["homepage_uri"] = s.homepage
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = %w(lib lib/jars)

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
