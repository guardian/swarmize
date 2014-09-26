require 'spec_helper'

describe CsvController do
  describe "GET #show" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :show, :swarm_id => 1
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
