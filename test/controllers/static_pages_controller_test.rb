require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | Lead Chicken Social Spy"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Lead Chicken Social Spy"
  end

  test "should get faq" do
    get :faq
    assert_response :success
    assert_select "title", "FAQ | Lead Chicken Social Spy"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | Lead Chicken Social Spy"
  end

end
