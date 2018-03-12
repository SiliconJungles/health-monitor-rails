$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'doctor_strange/version'

Gem::Specification.new do |s|
  s.name = 'doctor-strange'
  s.version = DoctorStrange::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['SiliconJungles']
  s.email = ['developers@siliconjungles.com']
  s.license = 'MIT'
  s.homepage = 'https://github.com/SiliconJungles/doctor-strange'
  s.summary = 'A Rails plug-in, which checks various services (db, cache, '\
    'sidekiq, redis, stripe, mailgun, etc.)'
  s.description = 'A Rails plug-in, which checks various services (db, cache, '\
    'sidekiq, redis, stripe, mailgun, etc.).'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.0'

  s.add_development_dependency 'appraisal', '~> 2.2', '>= 2.2.0'
  s.add_development_dependency 'capybara', '~> 2.18', '>= 2.18.0'
  s.add_development_dependency 'capybara-screenshot', '~> 1.0', '>= 1.0.18'
  s.add_development_dependency 'coveralls', '~> 0.8', '>= 0.8.21'
  s.add_development_dependency 'database_cleaner', '~> 1.6', '>= 1.6.2'
  s.add_development_dependency 'mailgun-ruby', '~> 1.1', '>= 1.1.9'
  s.add_development_dependency 'pry', '~> 0.11.3'
  s.add_development_dependency 'rake', '~> 0.8', '>= 0.8.7'
  s.add_development_dependency 'rediska', '~> 0.5', '>= 0.5.0'
  s.add_development_dependency 'resque', '~> 1.27', '>= 1.27.4'
  s.add_development_dependency 'rspec-rails', '~> 3.7', '>= 3.7.2'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.3.0'
  s.add_development_dependency 'rubocop', '~> 0.5'
  s.add_development_dependency 'sidekiq', '~> 3.0'
  s.add_development_dependency 'spork', '~> 0.9.2'
  s.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
  s.add_development_dependency 'stripe', '~> 3.11', '>= 3.11.0'
  s.add_development_dependency 'timecop', '~> 0.9.1'
end
