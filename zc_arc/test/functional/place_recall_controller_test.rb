require File.dirname(__FILE__) + '/../test_helper'
require 'place_recall_controller'

# Re-raise errors caught by the controller.
class PlaceRecallController; def rescue_action(e) raise e end; end

class PlaceRecallControllerTest < Test::Unit::TestCase
  def setup
    @controller = PlaceRecallController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
