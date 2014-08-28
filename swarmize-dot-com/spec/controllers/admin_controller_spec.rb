require 'spec_helper'

describe AdminController do
  describe "GET #show" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :show
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a non-admin user" do
      before do
        user = Factory(:user)
        session[:user_id] = user.id
      end
      it "should redirect the user to the home page" do
        get :show
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :show
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as an admin user" do
      before do
        user = Factory(:admin)
        session[:user_id] = user.id
      end
      it "should render the show page" do
        get :show
        expect(response).to render_template :show
      end
    end
  end

end
