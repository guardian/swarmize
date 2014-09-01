require 'spec_helper'

shared_examples_for 'it redirects to the login path' do |method, endpoint, params|
  it "should redirect the user to the login form" do
    send(method,endpoint,params)
    expect(response).to redirect_to(login_path)
  end
end

shared_examples_for 'it needs a user with permissions on that swarm' do |method, endpoint, params|
  before do
    user = Factory(:user)
    swarm = Factory(:swarm)
    assoc = double('assoc', :find_by => swarm)
    allow(Swarm).to receive(:unspiked).and_return(assoc)

    session[:user_id] = user.id
  end

  it "should redirect the user to the home page" do
    send(method,endpoint,params)
    expect(response).to redirect_to root_path
  end
  it "should tell them they're not allowed to do that" do
    send(method,endpoint,params)
    expect(flash[:error]).to eq("You don't have permission to do that.")
  end
end

describe GraphsController do
  describe "GET #index" do
    describe "when not logged in" do
      it_should_behave_like "it redirects to the login path", :get, :index, :swarm_id => 1
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :get, :index, :swarm_id => 1
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)
        allow(swarm).to receive(:users).and_return([user])
        session[:user_id] = user.id
      end

      it "should render the index page" do
        get :index, :swarm_id => 1
        expect(response).to render_template :index
      end
    end

    describe "when logged in as an admin" do
      before do
        user = Factory(:admin)
        swarm = Factory(:swarm)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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
      it_should_behave_like "it redirects to the login path", :get, :new, :swarm_id => 1
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :get, :new, :swarm_id => 1
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

        allow(swarm).to receive(:users).and_return([user])
        session[:user_id] = user.id
      end

      it "should render the new page" do
        get :new, :swarm_id => 1
        expect(response).to render_template :new
      end
    end

    describe "when logged in as an admin" do
      before do
        user = Factory(:admin)
        swarm = Factory(:swarm)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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
      it_should_behave_like "it redirects to the login path", :post, :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :post, :create, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
    end

    describe "when logged in as a user with permissions on that swarm" do
      let(:user) { Factory.create(:user) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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

    describe "when logged in as a an admin" do
      let(:user) { Factory.create(:admin) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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
      it_should_behave_like "it redirects to the login path", :get, :edit, :swarm_id => 1, :id => 1
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :get, :edit, :swarm_id => 1, :id => 1
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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

    describe "when logged in as an admin" do
      before do
        user = Factory(:admin)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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
      it_should_behave_like "it redirects to the login path", :put, :update, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :get, :edit, :swarm_id => 1, :id => 1, graph: Factory.attributes_for(:graph)
    end

    describe "when logged in as a user with permissions on that swarm" do
      let(:user) { Factory.create(:user) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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

    describe "when logged in as an admin" do
      let(:user) { Factory.create(:admin) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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
      it_should_behave_like "it redirects to the login path", :get, :delete, :swarm_id => 1, :id => 1
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :get, :delete, :swarm_id => 1, :id => 1
    end

    describe "when logged in as a user with permissions on that swarm" do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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

    describe "when logged in as an admin" do
      before do
        user = Factory(:admin)
        swarm = Factory(:swarm)
        graph = Factory(:graph)

        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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
      it_should_behave_like "it redirects to the login path", :delete, :destroy, :swarm_id => 1, :id => 1
    end

    describe "when logged in as a user with no permissions on that swarm" do
      it_should_behave_like "it needs a user with permissions on that swarm", :delete, :destroy, :swarm_id => 1, :id => 1
    end

    describe "when logged in as a user with permissions on that swarm" do
      let(:user) { Factory.create(:user) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)

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

    describe "when logged in as an admin" do
      let(:user) { Factory.create(:admin) }
      let(:swarm) { Factory.build(:swarm) }
      let(:graph) { Factory.build(:graph) }

      before do
        assoc = double('assoc', :find_by => swarm)
        allow(Swarm).to receive(:unspiked).and_return(assoc)


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
