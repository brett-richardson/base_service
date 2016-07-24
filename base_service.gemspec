$LOAD_PATH.unshift File.expand_path '../lib', __FILE__
require 'base_service/version'

Gem::Specification.new do |s|
	s.name         = 'base_service'
	s.summary      = 'Base Service for Ruby'
	s.description  = 'Template for service objects in ruby'
	s.version      =  BaseService::VERSION
	s.date         = '2016-06-24'
	s.homepage     = 'http://www.mebrett.com'
	s.authors      = ['Brett Richardson']
  s.email        = ['brett.richardson.nz@gmail.com']
	s.require_path = 'lib'
	s.files        = Dir.glob('lib/**/*') + %w{Gemfile Guardfile MIT-LICENSE README.md}

  s.add_dependency 'activesupport', '~> 4.0'

	s.add_development_dependency 'bundler'
	s.add_development_dependency 'rspec'
	s.add_development_dependency 'rspec-its'
	s.add_development_dependency 'rake'
	s.add_development_dependency 'guard'
	s.add_development_dependency 'guard-rspec'
	s.add_development_dependency 'pry'
end
