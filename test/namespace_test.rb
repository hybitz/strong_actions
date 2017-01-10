require 'test_helper'

module SysAdmin
  class SysAdmin::SysConfigController < ActionController::Base
    include StrongActions::Controller

    def show
      head :ok
    end

    def edit
      head :ok
    end

    def update
      head :ok
    end

    private

    def current_user
      unless @current_user
        @current_user = Object.new
        @current_user.instance_eval do
           def sys_admin?
             false
           end
        end
      end

      @current_user
    end

  end
end

class NamespaceTest < ActionController::TestCase
  tests SysAdmin::SysConfigController

  def test_allowed
    get :show
    assert_response :ok
  end

  def test_forbidden
    assert_raise StrongActions::ForbiddenAction do
      get :edit
    end
    assert_raise StrongActions::ForbiddenAction do
      patch :update
    end
  end

end
