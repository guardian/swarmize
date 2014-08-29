require 'spec_helper'
require 'controllers/shared_examples_for_controllers'

describe SwarmsController do
  describe "GET #index" do
    it_should_behave_like "it works for any user", :get, :index
  end

  describe "GET #draft" do
    it_should_behave_like "it works for any user", :get, :draft
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


  describe "DELETE #destroy" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        delete :destroy, :id => 1
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
        delete :destroy, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        delete :destroy, :id => 1
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
        expect(swarm).to receive(:destroy)
        delete :destroy, :id => 1
      end

      it "redirect to the swarms path" do
        delete :destroy, :id => 1
        expect(response).to redirect_to swarms_path
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

  # GET #edit
  describe "GET #edit" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :edit, :id => 1
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
        get :edit, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :edit, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and has permission the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should render the edit page" do
        get :edit, :id => 1
        expect(response).to render_template :edit
      end
    end
  end

  # PUT #update
  describe "PUT #update" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        put :update, :id => 1, swarm: {name: "name", description: 'desc'}
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
        put :update, :id => 1, swarm: {name: "name", description: 'desc'}
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        put :update, :id => 1, swarm: {name: "name", description: 'desc'}
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and has permission the swarm' do
      let(:swarm) {Factory(:swarm)}
      before do
        user = Factory(:user)
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should update the swarm" do
        expect(swarm).to receive(:update).with({'name' => 'name', 'description' => 'desc'})
        put :update, :id => 1, swarm: {name: "name", description: 'desc'}
      end

      it "redirect to the swarm fields page" do
        put :update, :id => 1, swarm: {name: "name", description: 'desc'}
        expect(response).to redirect_to fields_swarm_path(swarm)
      end
    end
  end

  # GET #fields
  describe "GET #fields" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :fields, :id => 1
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
        get :fields, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :fields, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and has permission the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should render the fields page" do
        get :fields, :id => 1
        expect(response).to render_template :fields
      end
    end
  end

  # POST #update_fields
  describe "POST #update_fields" do
    let(:sample_params) { {"authenticity_token"=>"WuFajnsb2vFRJQjtfs9+iAsLgDqN5AdQb87/4CX2RSw=", "fields"=>[{"id"=>"110", "field_index"=>"0", "field_type"=>"yesno", "field_name"=>"Can you get broadband where you live?", "hint"=>"", "compulsory"=>"true"}, {"id"=>"111", "field_index"=>"1", "field_type"=>"pick_one", "field_name"=>"Who is your Broadband supplier", "hint"=>"", "possible_values"=>["BT", "Virgin", "O2", "Other"], "compulsory"=>"true"}, {"id"=>"112", "field_index"=>"2", "field_type"=>"postcode", "field_name"=>"What is your postcode?", "hint"=>"", "sample_value"=>"eg. GL52 9HR", "compulsory"=>"true"}, {"id"=>"113", "field_index"=>"3", "field_type"=>"email", "field_name"=>"What is your email address?", "hint"=>"Your email address will never be made public.", "sample_value"=>"", "compulsory"=>"true"}], "update_and_next"=>"Preview Swarm", "id"=>"dmntqpwu"} }

    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        post :update_fields, {:id => 1}.merge(sample_params)
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
        post :update_fields, {:id => 1}.merge(sample_params)
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        post :update_fields, {:id => 1}.merge(sample_params)
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and has permission on the swarm' do
      let(:swarm) {Factory(:swarm)}
      before do
        user = Factory(:user)
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      describe "which has opened" do
        it "should update the swarm fields" do
          allow(swarm).to receive(:has_opened?).and_return(true)
          fake_field = double('field')
          fake_fields_association = double('fields_assoc', :find => fake_field)
          allow(swarm).to receive(:swarm_fields).and_return(fake_fields_association)

          expect(fake_field).to receive(:update).exactly(sample_params['fields'].size).times

          post :update_fields, {:id => 1}.merge(sample_params)
        end

      end
      describe "which hasn't opened" do
        it "should blow away the fields" do
          allow(swarm).to receive(:has_opened?).and_return(false)

          fake_fields_association = double('fields_assoc', :create => true)
          allow(swarm).to receive(:swarm_fields).and_return(fake_fields_association)

          expect(fake_fields_association).to receive(:destroy_all)
          post :update_fields, {:id => 1}.merge(sample_params)
        end

        it "should recreate the fields" do
          allow(swarm).to receive(:has_opened?).and_return(false)


          fake_fields_association = double('fields_assoc', :destroy_all => true)
          allow(swarm).to receive(:swarm_fields).and_return(fake_fields_association)

          expect(fake_fields_association).to receive(:create).exactly(sample_params['fields'].size).times
          post :update_fields, {:id => 1}.merge(sample_params)
        end
      end

      it "redirect to the preview page if update_and_next is set" do
        post :update_fields, {:id => 1}.merge(sample_params)
        expect(response).to redirect_to preview_swarm_path(swarm)
      end

      it "redirect to the edit page if update_and_next is notset" do
        post :update_fields, {:id => 1}.merge(sample_params).merge({:update_and_next => nil})
        expect(response).to redirect_to edit_swarm_path(swarm)
      end
    end
  end

  # GET #preview
  describe "GET #preview" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :preview, :id => 1
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
        get :preview, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :preview, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and has permission the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should render the preview page" do
        get :preview, :id => 1
        expect(response).to render_template :preview
      end
    end
  end

  # GET #code
  describe "GET #code" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        get :code, :id => 1
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
        get :code, :id => 1
        expect(response).to redirect_to root_path
      end
      it "should tell them they're not allowed to do that" do
        get :code, :id => 1
        expect(flash[:error]).to eq("You don't have permission to do that.")
      end
    end

    describe 'for a user who is logged in and has permission the swarm' do
      before do
        user = Factory(:user)
        swarm = Factory(:swarm)
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should render the code page" do
        get :code, :id => 1
        expect(response).to render_template :code
      end
    end
  end

  describe "POST #clone" do
    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        delete :destroy, :id => 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'for a user who is logged in' do
      let(:swarm) { Factory(:swarm) }
      let(:user) { Factory(:user) }
      let(:second_swarm) { FactoryGirl.build_stubbed(:swarm) }

      before do
        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)

        allow(swarm).to receive(:clone_by).and_return(second_swarm)

        session[:user_id] = user.id
      end

      it "should redirect the user to the new swarm" do
        post :clone, :id => 1
        expect(response).to redirect_to swarm_path(second_swarm.token)
      end

      it "should clone the swarm" do
        expect(swarm).to receive(:clone_by).with(user)
        post :clone, :id => 1
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
        expect(swarm).to receive(:destroy)
        delete :destroy, :id => 1
      end

      it "redirect to the swarms path" do
        delete :destroy, :id => 1
        expect(response).to redirect_to swarms_path
      end
    end
  end

  # POST #open
  describe "POST #open" do
    let(:sample_params) {
      {'open_year' => '2014',
       'open_month' => '8',
       'open_day' => '29',
       'open_hour' => '17',
       'open_minute' => '32'
      }
    }

    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        post :open, {:id => 1}.merge(sample_params)
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'for a user who is logged in and has permissions on the swarm' do
      let(:user) { Factory(:user) }
      let(:swarm) { Factory(:swarm) }

      before do
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should redirect to the swarm page" do
        post :open, {:id => 1}.merge(sample_params)
        expect(response).to redirect_to swarm_path(swarm)
      end

      it "should update the swarm" do
        expect(swarm).to receive(:update)
        post :open, {:id => 1}.merge(sample_params)
      end
    end
  end

  # POST #close
  describe "POST #close" do
    let(:sample_params) {
      {'close_year' => '2014',
       'close_month' => '8',
       'close_day' => '29',
       'close_hour' => '17',
       'close_minute' => '32'
      }
    }

    describe 'for a user who is not logged in' do
      it "should redirect to login" do
        post :close, {:id => 1}.merge(sample_params)
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'for a user who is logged in and has permissions on the swarm' do
      let(:user) { Factory(:user) }
      let(:swarm) { Factory(:swarm) }

      before do
        allow(swarm).to receive(:users).and_return([user])

        assoc = double("swarms", :find_by => swarm)

        allow(Swarm).to receive(:unspiked).and_return(assoc)
        session[:user_id] = user.id
      end

      it "should redirect to the swarm page" do
        post :close, {:id => 1}.merge(sample_params)
        expect(response).to redirect_to swarm_path(swarm)
      end

      it "should update the swarm" do
        expect(swarm).to receive(:update)
        post :close, {:id => 1}.merge(sample_params)
      end

      describe "attempting to set the close time before the start time" do
        it "should tell them they can't do that" do
          allow(swarm).to receive(:update).and_raise(TimeParadoxError)
          post :close, {:id => 1}.merge(sample_params)
          expect(flash[:error]).to eq("Swarm cannot close before it has opened!")
        end
      end
    end
  end



end
