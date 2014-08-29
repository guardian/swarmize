require 'spec_helper'

describe SwarmsController do
  describe "GET #index" do
    describe "for any user" do
      it "should be a success" do
        get :index
        expect(response.status).to be(200)
      end

      it "should render the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #yet_to_open" do
    describe "for any user" do
      it "should be a success" do
        get :yet_to_open
        expect(response.status).to be(200)
      end

      it "should render the yet_to_open template" do
        get :yet_to_open
        expect(response).to render_template(:yet_to_open)
      end
    end
  end

  describe "GET #live" do
    describe "for any user" do
      it "should be a success" do
        get :live
        expect(response.status).to be(200)
      end

      it "should render the live template" do
        get :live
        expect(response).to render_template(:live)
      end
    end
  end
  
  describe "GET #closed" do
    describe "for any user" do
      it "should be a success" do
        get :closed
        expect(response.status).to be(200)
      end

      it "should render the closed template" do
        get :closed
        expect(response).to render_template(:closed)
      end
    end
  end
  
  describe "GET #mine" do
    describe "for a user who is not logged in" do
      it "should redirect to login" do
        get :mine
        expect(response).to redirect_to(login_path)
      end
    end

    describe "for a logged-in user" do
      before do
        user = Factory.build(:user)
        session[:user_id] = 1
        allow(user).to receive(:id).and_return(1)
        allow(User).to receive(:find).and_return(user)
      end

      it "should redirect to the user page" do
        get :mine
        expect(response).to redirect_to(user_path(1))
      end
    end
  end
  
  describe "GET #new" do
    describe "for a user who is not logged in" do
      it "should redirect to login" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    describe "for a logged-in user" do
      before do
        user = Factory.build(:user)
        session[:user_id] = 1
        allow(User).to receive(:find).and_return(user)
      end

      it "should return a success" do
        get :new
        expect(response.status).to eq(200)
      end
      it "should render the new template" do
        get :new
        expect(response).to render_template :new
      end
    end

  end

end
