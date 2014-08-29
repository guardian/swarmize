require 'spec_helper'
require 'controllers/shared_examples_for_controllers'

describe AdminController do
  describe "GET #show" do
    it_should_behave_like "it needs an admin user", :get, :show
  end

end
