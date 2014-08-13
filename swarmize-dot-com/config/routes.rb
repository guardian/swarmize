Swarmize::Application.routes.draw do
  root "home#show"

  resources :swarms do
    member do
      get 'fields'
      get 'preview'
      get 'embed'
      get 'delete'
      get 'spike'
      get 'csv'
      post 'update_fields'
      post 'open'
      post 'close'
      post 'clone'
      post 'do_spike'
    end

    collection do
      get 'mine'
      get 'yet_to_open'
      get 'live'
      get 'closed'
    end
  end

  resources :users do
    member do
      get 'delete'
      get 'yet_to_open'
      get 'live'
      get 'closed'
    end
  end

  resource :search, :controller => "search" do
    member do
      get 'results'
    end
  end

  resource :home, :controller => "home"

  resource :admin, :controller => "admin" do
    collection do
      post 'dummy_up'
      post 'delete_dummy'
      post 'create_dummy_users'
      post 'create_dummy_swarms'
      post 'regenerate_tokens'
    end
  end

  resource :session do
    collection do
      get 'logout'
    end
  end

  get '/auth/google_oauth2/callback', to: 'sessions#callback'

  get 'swarms/:swarm_id/graphs/count/:count_field', to: 'graphs#aggregate_count'
  get 'swarms/:swarm_id/graphs/count/:count_field/:unique_field', to: 'graphs#cardinal_count'
end
