require File.dirname(__FILE__) + '/../test_helper'
require 'doc_approval_controller'

# Re-raise errors caught by the controller.
class DocApprovalController; def rescue_action(e) raise e end; end

class DocApprovalControllerTest < Test::Unit::TestCase
  def setup
    @controller = DocApprovalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
