require 'spec_helper'

describe GraphsController do
  describe "GET #index" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :index, :swarm_id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(Swarm).to receive(:find_by).and_return(swarm)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        get :index, :swarm_id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :index, :swarm_id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)

        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])
        session[:user_id] = user.id
      end

      it "should render the index page" do
        get :index, :swarm_id => 1
        expect(response).to render_template :index
      end
    end
  end

  #NEW
  describe "GET #new" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :new, :swarm_id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(Swarm).to receive(:find_by).and_return(swarm)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        get :new, :swarm_id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :new, :swarm_id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)

        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])
        session[:user_id] = user.id
      end

      it "should render the new page" do
        get :new, :swarm_id => 1
        expect(response).to render_template :new
      end
    end
  end

  #CREATE
  describe "POST #create" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        post :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(Swarm).to receive(:find_by).and_return(swarm)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        post :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        post :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      let(:user) { Factory.create(:user) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])

        graphs_association = double
        allow(swarm).to receive(:graphs).and_return(graphs_association)
        allow(graphs_association).to receive(:new).and_return(graph)
        allow(graph).to receive(:options=)
        allow(graph).to receive(:save)

        session[:user_id] = user.id
      end

      it "should redirect to the swarm graphs page" do
        post :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(response).to redirect_to swarm_graphs_path(swarm.token)
      end

      it "should create the graph" do
        expect(graph).to receive(:save)
        post :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
      end
    end
  end
  
  #EDIT
  describe "GET #edit" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :edit, :swarm_id => 1, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(Graph).to receive(:find_by).and_return(graph)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        get :edit, :swarm_id => 1, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :edit, :swarm_id => 1, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])

        graphs_association = double
        allow(swarm).to receive(:graphs).and_return(graphs_association)
        allow(graphs_association).to receive(:find).and_return(graph)

        session[:user_id] = user.id
      end

      it "should render the edit page" do
        get :edit, :swarm_id => 1, :id => 1
        expect(response).to render_template :edit
      end
    end
  end

  #UPDATE
  describe "PUT #update" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        put :update, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(Swarm).to receive(:find_by).and_return(swarm)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        put :update, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        put :update, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      let(:user) { Factory.create(:user) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])

        graphs_association = double
        allow(swarm).to receive(:graphs).and_return(graphs_association)
        allow(graphs_association).to receive(:find).and_return(graph)
        allow(graph).to receive(:options=)
        allow(graph).to receive(:save)

        session[:user_id] = user.id
      end

      it "should redirect to the swarm graphs page" do
        put :update, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
        expect(response).to redirect_to swarm_graphs_path(swarm.token)
      end

      it "should create the graph" do
        expect(graph).to receive(:save)
        put :update, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
      end
    end
  end

  #DELETE
  describe "GET #delete" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        get :delete, :swarm_id => 1, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(Graph).to receive(:find_by).and_return(graph)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        get :delete, :swarm_id => 1, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :delete, :swarm_id => 1, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])

        graphs_association = double
        allow(swarm).to receive(:graphs).and_return(graphs_association)
        allow(graphs_association).to receive(:find).and_return(graph)

        session[:user_id] = user.id
      end

      it "should render the delete page" do
        get :delete, :swarm_id => 1, :id => 1
        expect(response).to render_template :delete
      end
    end
  end

  #DESTROY
  describe "DELETE #destroy" do
    describe "when not logged in" do
      it "should redirect the user to the login form" do
        delete :destroy, :swarm_id => 1, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in as a user with no permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(Swarm).to receive(:find_by).and_return(swarm)
        session[:user_id] = user.id
      end

      it "should redirect the user to the home page" do
        delete :destroy, :swarm_id => 1, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        delete :destroy, :swarm_id => 1, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe "when logged in as a user with permissions on that swarm" do
      let(:user) { Factory.create(:user) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        allow(Swarm).to receive(:find_by).and_return(swarm)
        allow(swarm).to receive(:users).and_return([user])

        graphs_association = double
        allow(swarm).to receive(:graphs).and_return(graphs_association)
        allow(graphs_association).to receive(:find).and_return(graph)

        session[:user_id] = user.id
      end

      it "should redirect to the swarm graphs page" do
        delete :destroy, :swarm_id => 1, :id => 1
        expect(response).to redirect_to swarm_graphs_path(swarm.token)
      end

      it "should destroy the graph in question" do
        expect(graph).to receive(:destroy)
        delete :destroy, :swarm_id => 1, :id => 1
      end
    end
  end

end
