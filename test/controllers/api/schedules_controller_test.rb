require 'test_helper'

class Api::SchedulesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end


  test "should get create" do
    get :create
    assert_response :success
  end


end
