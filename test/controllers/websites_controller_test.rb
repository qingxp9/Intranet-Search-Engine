require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  setup do
    @website = websites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:websites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create website" do
    assert_difference('Website.count') do
      post :create, website: { body: @website.body, check_time: @website.check_time, description: @website.description, headers: @website.headers, http_server: @website.http_server, keywords: @website.keywords, os: @website.os, port: @website.port, target: @website.target, title: @website.title, webapp: @website.webapp }
    end

    assert_redirected_to website_path(assigns(:website))
  end

  test "should show website" do
    get :show, id: @website
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @website
    assert_response :success
  end

  test "should update website" do
    patch :update, id: @website, website: { body: @website.body, check_time: @website.check_time, description: @website.description, headers: @website.headers, http_server: @website.http_server, keywords: @website.keywords, os: @website.os, port: @website.port, target: @website.target, title: @website.title, webapp: @website.webapp }
    assert_redirected_to website_path(assigns(:website))
  end

  test "should destroy website" do
    assert_difference('Website.count', -1) do
      delete :destroy, id: @website
    end

    assert_redirected_to websites_path
  end
end
