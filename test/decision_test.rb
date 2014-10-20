require 'test_helper'

class DecisionTest < Minitest::Test

  def setup
    StrongActions.config.config_files = File.join(File.dirname(__FILE__), 'config', 'acl.yml')
  end

  def decision
    @decision ||= StrongActions::Decision.new(self)
  end

  def current_user
    @user ||= User.new
  end

  def test_controller_true
    assert decision.call('current_user', 'books')
  end

  def test_controller_false
    assert ! decision.call('current_user', 'end_of_services')
  end

  def test_action_true
    assert decision.call('current_user', 'welcome', 'index')
  end

  def test_action_false
    assert ! decision.call('current_user', 'welcome', 'destroy')
  end

  def test_action_default_to_index
    assert decision.call('current_user', 'welcome')
    assert ! decision.call('current_user', 'sessions')
  end

  def test_admin_for_new
    current_user.admin = false
    assert decision.call('current_user', 'stores')
    assert ! decision.call('current_user', 'stores', 'new')

    current_user.admin = true
    assert decision.call('current_user', 'stores')
    assert decision.call('current_user', 'stores', 'new')
  end

  def test_role_undefined_and_not_needed
    assert decision.call('current_user', 'some_actions')
    assert decision.call('undefined', 'some_actions')
  end

end

class User
  attr_accessor :admin
  
  def admin?
    admin
  end
end