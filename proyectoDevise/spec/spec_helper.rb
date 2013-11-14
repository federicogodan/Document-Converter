# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  def registroChechab
      u1 = User.new(email:"checha@hola.com", nick:"chechab", password:"holamundo")
      u1.save
  end  
  
  def register_user  
      u = User.new(email: "test@email.com", nick: "test_nik", password: "password", name: "im_test", surname: "surnm_test")
      u.save
      return u
  end
  
  def add_format
      f = Format.new(name:"html")
      f.save
      return f
  end
  
  def add_formats
    f1 = Format.new(name:"pdf")
    f2 = Format.new(name:"doc")
    f3 = Format.new(name:"odt")
    f4 = Format.new(name:"txt")
    f5 = Format.new(name:"xml")
    
    f1.save
    f2.save
    f3.save
    f4.save
    f5.save
  end
end
