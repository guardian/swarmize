shared_examples_for "it works for any user" do |method, endpoint, params|
  context "so for any user" do
    it "should be a success" do
      send(method, endpoint, params)
      expect(response.status).to be(200)
    end

    it "should render the #{endpoint} template" do
      send(method, endpoint, params)
      expect(response).to render_template(endpoint)
    end
  end

end

shared_examples_for "it needs login" do |method,endpoint, params|
  context "so for a user who is not logged in" do
    it "should redirect to login" do
      send(method, endpoint, params)
      expect(response).to redirect_to(login_path)
    end
  end

  context "so for a logged-in user" do
    before do
      user = FactoryGirl.build(:user)
      session[:user_id] = 1
      allow(User).to receive(:find).and_return(user)
    end

    it "should return a success" do
      send(method, endpoint, params)
      expect(response.status).to eq(200)
    end
    it "should render the #{endpoint} template" do
      send(method, endpoint, params)
      expect(response).to render_template endpoint
    end
  end
end

shared_examples_for "it needs an admin user" do |method, endpoint, params|
  context "so when not logged in" do
    it "should redirect the user to the login form" do
      send(method, endpoint, params)
      expect(response).to redirect_to(login_path)
    end
  end

  context "so when logged in as a non-admin user" do
    before do
      user = FactoryGirl.build(:user)
      session[:user_id] = 1
      allow(User).to receive(:find).and_return(user)
    end
    it "should redirect the user to the home page" do
      send(method, endpoint, params)
      expect(response).to redirect_to root_path
    end
    it "should tell them they're not allowed to do that" do
      send(method, endpoint, params)
      expect(flash[:error]).to eq("You don't have permission to do that.")
    end
  end

  context "so when logged in as an admin user" do
    before do
      admin = FactoryGirl.build(:admin)
      session[:user_id] = 1
      allow(User).to receive(:find).and_return(admin)
    end
    it "should render the show page" do
      send(method, endpoint, params)
      expect(response).to render_template endpoint
    end
  end
end

