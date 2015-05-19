require 'test_helper'

class ParseControllerTest < ActionController::TestCase
  test "should get whatweb_read" do
    get :whatweb_read
    assert_response :success
  end

  test "should get nmap_read" do
    get :nmap_read
    assert_response :success
  end

end
