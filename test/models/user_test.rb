require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "That models user model has when eagerloaded hits" do
    user = User.includes(:hits).first
    p user.hits
    assert_equal true, user.association(:hits).loaded?
  end
end
