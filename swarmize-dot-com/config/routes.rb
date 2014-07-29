Swarmize::Application.routes.draw do
  root "swarms#index"

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
  end

  resources :users do
    member do
      get 'delete'
    end
  end

  resource :search, :controller => "search" do
    member do
      get 'results'
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
