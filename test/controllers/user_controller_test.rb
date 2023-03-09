require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest

  test "dipslay all users" do
    get "/user/all"
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal users[0]["username"], body[0]["username"]
  end

  test "dipslay a single User" do
    get "/user/#{User.first.id}"
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal users[0].username, body["username"]
  end

  test "Test when the user doesn't exist on showing single User" do
    get "/user/#{User.last.id + 1}"
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "invalid user", body["error"]
  end

  test "Test over quota limit from current user model" do
    User.any_instance.expects(:count_hits).returns(300000)
    get "/user/#{User.first.id}/hit_endpoint"
    body = JSON.parse(response.body)
    assert_equal "over quota", body["error"]
  end

  test "Test when it's not over quota without timezone" do
    User.any_instance.expects(:count_hits).returns(1000)
    user = User.first
    count = user.hits.count
    get "/user/#{User.first.id}/hit_endpoint"
    body = JSON.parse(response.body)
    assert_response :success
    # Asserts that the hit counts increases
    assert_equal count + 1, user.hits.count
    assert_equal true, body.has_key?("data")
  end

  test "Test when it's not over quota with timezone" do
    User.any_instance.expects(:count_hits).returns(1000)
    user = User.first
    count = user.hits.count
    get "/user/#{User.first.id}/hit_endpoint/Sydney"
    body = JSON.parse(response.body)
    assert_response :success
    # Asserts that the hit counts increases
    assert_equal count + 1, user.hits.count
    assert_equal true, body.has_key?("data")

    # test that the time zone changes
    user = User.first

    assert_equal user.time_zone, "Sydney"
  end
end
