require 'spec_helper'
require 'controllers/shared_examples_for_controllers'

describe SearchController do
  describe "GET #results" do
    it_should_behave_like "it needs login", :get, :results, :query => 'swarm'
  end

end
