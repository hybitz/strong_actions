# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'minitest/autorun'
require 'rails'

ActiveSupport.test_order = :sorted

class FakeApplication < Rails::Application
end

Rails.application = FakeApplication

require 'strong_actions'

module ActionController
  SharedTestRoutes = ActionDispatch::Routing::RouteSet.new
  SharedTestRoutes.draw do
    get ':controller(/:action)'
    delete ':controller(/:action)'
  end

  class Base
    include ActionController::Testing
    include SharedTestRoutes.url_helpers
  end
  
  class ActionController::TestCase
    setup do
      @routes = SharedTestRoutes
    end
  end
end
