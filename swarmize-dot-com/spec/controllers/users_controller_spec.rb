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
        user = FactoryGirl.create(:user)
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
        user = FactoryGirl.create(:admin)
        session[:user_id] = user.id
      end
      it "should render the index page" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #draft" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :draft, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as neither the user in question or an admin" do
      before do
        user = FactoryGirl.create(:user)
        session[:user_id] = user.id
        allow(User).to receive(:find).with('1').and_return(FactoryGirl.build(:user))
        allow(User).to receive(:find).with(user.id).and_return(user)
      end

      it "should redirect the user to the root path" do
        get :draft, :id => 1
        expect(response).to redirect_to(root_path)
      end
      it "should tell them they're not allowed to do that" do
        get :draft, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when as the user in question" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        session[:user_id] = user.id
      end

      it "should be a success" do
        get :draft, :id => user.id
        expect(response.status).to eq(200)
      end
      it "should render the drafts list" do
        get :draft, :id => user.id 
        expect(response).to render_template(:draft)
      end
    end

    describe "when as an admin" do
      before do
        user = FactoryGirl.create(:admin)
        session[:user_id] = user.id
        allow(User).to receive(:find).with('1').and_return(FactoryGirl.build(:user))
        allow(User).to receive(:find).with(user.id).and_return(user)
      end

      it "should be a success" do
        get :draft, :id => 1
        expect(response.status).to eq(200)
      end
      it "should render the drafts list" do
        get :draft, :id => 1
        expect(response).to render_template(:draft)
      end
    end
  end

  describe "GET #delete" do
    let(:user_to_delete) { FactoryGirl.create(:user) }

    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :delete, id: user_to_delete.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a non-admin user" do
      before do
        user = FactoryGirl.create(:user)
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
        user = FactoryGirl.create(:admin)
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
        user = FactoryGirl.create(:user)
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
      let(:user_to_delete) { FactoryGirl.build(:user) }

      before do
        admin = FactoryGirl.create(:admin)
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
