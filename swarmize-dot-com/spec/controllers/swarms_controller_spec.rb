require 'spec_helper'
require 'controllers/shared_examples_for_controllers'

describe SwarmsController do
  describe "GET #index" do
    it_should_behave_like "it works for any user", :get, :index
  end

  describe "GET #yet_to_open" do
    it_should_behave_like "it works for any user", :get, :yet_to_open
  end

  describe "GET #live" do
    it_should_behave_like "it works for any user", :get, :live
  end
  
  describe "GET #closed" do
    it_should_behave_like "it works for any user", :get, :closed
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
    it_should_behave_like "it needs login", :get, :new
  end

  describe "GET #csv" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :csv, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #delete" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :delete, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #spike" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :spike, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'for a user who is logged in but not an owner of the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        get :spike, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :spike, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and owns the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(swarm).to receive(:owners).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should render the spike page" do
        get :spike, :id => 1
        expect(response).to render_template :spike
      end
    end
  end

  describe "POST #do_spike" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        post :do_spike, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'for a user who is logged in but not an owner of the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        post :do_spike, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        post :do_spike, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and owns the swarm' do
      let(:swarm) {Factory(:swarm)}

      before do
        user = Factory(:user)
        allow(swarm).to receive(:owners).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should spike the swarm" do
        expect(swarm).to receive(:spike!)
        post :do_spike, :id => 1
      end

      it "redirect to the swarms path" do
        post :do_spike, :id => 1
        expect(response).to redirect_to swarms_path
      end
    end
  end
end
