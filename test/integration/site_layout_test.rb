require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", faq_path, count: 2, text: 'FAQ'
    assert_select "a[href=?]", tutorial_path, count: 2, text: 'Tutorial'
    assert_select "a[href=?]", contact_path, count: 2, text: 'Contact'
  end
end
