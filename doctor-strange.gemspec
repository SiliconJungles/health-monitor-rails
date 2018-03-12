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
  s.summary = 'Monitoring Rails plug-in, which checks various services (db, cache, '\
    'sidekiq, redis, email, etc.)'
  s.description = 'Monitoring Rails plug-in, which checks various services (db, cache, '\
    'sidekiq, redis, email, etc.).'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.0'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rediska'
  s.add_development_dependency 'resque'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '>= 0.5'
  s.add_development_dependency 'sidekiq', '>= 3.0'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'mailgun-ruby'
  s.add_development_dependency 'stripe'
end
