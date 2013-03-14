PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require 'capybara/rspec'
Capybara.app = YellowJersey
Capybara.save_and_open_page_path = Dir.pwd

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  YellowJersey.tap { |app|  }
end
