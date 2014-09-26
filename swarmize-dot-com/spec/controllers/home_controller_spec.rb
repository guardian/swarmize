require 'spec_helper'

describe HomeController do
  render_views

  describe "GET #show" do
    describe "when logged out" do
      it "renders the show page" do
        get :show
        expect(response).to render_template :show
      end

      it "renders the logged out partial" do
        get :show
        expect(response).to render_template(:partial => "home/_logged_out")
      end

    end

    describe "when logged in" do
      before do
        user = FactoryGirl.create(:user)
        session[:user_id] = user.id
      end

      it "renders the logged in partial" do
        get :show
        expect(response).to render_template(:partial => "home/_logged_in")
      end
    end

  end

end
