PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require 'capybara/rspec'
Capybara.app = YellowJersey
Capybara.save_and_open_page_path = Dir.pwd

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  # Cleaner
  DatabaseCleaner[:mongoid].strategy = :truncation
  conf.before(:each) do
    DatabaseCleaner[:mongoid].clean

    account = Account.create(
      :email => 'test@test.com',
      :name => 'testy',
      :surname => 'tester',
      :password => 'password',
      :password_confirmation => 'password',
      :role => "athlete")
  end
  conf.after(:each) { DatabaseCleaner[:mongoid].clean }
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  YellowJersey.tap { |app|  }
end
