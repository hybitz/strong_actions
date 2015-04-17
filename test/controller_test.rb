require 'test_helper'

class WelcomeController < ActionController::Base
  include StrongActions::Controller

  def index
    head :ok
  end
  
  def destroy
    head :ok
  end

  private

  def current_user
    unless @current_user
      @current_user = Object.new
      @current_user.instance_eval do
         def admin?
           false
         end
      end
    end
    
    @current_user
  end
end

class ControllerTest < ActionController::TestCase
  tests WelcomeController

  def test_allowed
    get :index
    assert_response :ok
  end

  def test_forbidden
    assert_raise StrongActions::ForbiddenAction do
      delete :destroy
    end
  end

end
