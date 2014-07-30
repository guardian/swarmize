Swarmize::Application.routes.draw do
  root "home#show"

  resources :swarms do
    member do
      get 'fields'
      get 'preview'
      get 'embed'
      get 'delete'
      post 'update_fields'
      post 'open'
      post 'close'
      post 'clone'
    end

    collection do
      get 'mine'
    end
  end

  resources :users do
    member do
      get 'delete'
      get 'open'
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

  resource :session do
    collection do
      get 'logout'
    end
  end

  get '/auth/google_oauth2/callback', to: 'sessions#callback'

  get 'swarms/:swarm_id/graphs/count/:count_field', to: 'graphs#aggregate_count'
  get 'swarms/:swarm_id/graphs/count/:count_field/:unique_field', to: 'graphs#cardinal_count'
end
