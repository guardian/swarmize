require 'spec_helper'

describe UsersController do
  describe "GET #index" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a non-admin user" do
      before do
        user = Factory(:user)
        session[:user_id] = user.id
      end
      it "should redirect the user to the home page" do
        get :index
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :index
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as an admin user" do
      before do
        user = Factory(:admin)
        session[:user_id] = user.id
      end
      it "should render the index page" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #delete" do
    let(:user_to_delete) { Factory.create(:user) }

    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :delete, id: user_to_delete.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a non-admin user" do
      before do
        user = Factory(:user)
        session[:user_id] = user.id
      end
      it "should redirect the user to the home page" do
        get :delete, id: user_to_delete
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :delete, id: user_to_delete
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as an admin user" do
      before do
        user = Factory(:admin)
        session[:user_id] = user.id
      end
      it "should render the delete page" do
        get :delete, id: user_to_delete
        expect(response).to render_template :delete
      end
    end
  end


  describe "DELETE #destroy" do

    describe "when not logged in" do
      it "should redirect the user to the login form" do
        delete :destroy, id: 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a non-admin user" do
      before do
        user = Factory(:user)
        session[:user_id] = user.id
      end
      it "should redirect the user to the home page" do
        delete :destroy, id: 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        delete :destroy, id: 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as an admin user" do
      let(:user_to_delete) { Factory.build(:user) }

      before do
        admin = Factory(:admin)
        session[:user_id] = admin.id
        allow(User).to receive(:find).with(admin.id).and_return(admin)
        allow(User).to receive(:find).with('1').and_return(user_to_delete)
      end
       
      it "should call destroy on the user in question" do
        expect(user_to_delete).to receive(:destroy)
        delete :destroy, id: 1
      end

      it "it should redirect to the users index" do
        delete :destroy, id: 1
        expect(response).to redirect_to users_path
      end
    end
  end
end
