Swarmize::Application.routes.draw do
  root to: "home#show"

  resources :swarms do
    resources :permissions
    resources :api_keys
    resources :graphs do
      member do
        get 'delete'
      end
    end
    resource :csv, :controller => 'csv' do
      #collection do
        #get 'public'
      #end
    end
    member do
      get 'fields'
      get 'preview'
      get 'embed'
      get 'delete'
      get 'latest'
      get 'entrycount'
      get 'code'
      post 'update_fields'
      post 'open'
      post 'close'
      post 'clone'
    end

    collection do
      get 'mine'
      get 'draft'
      get 'live'
      get 'closed'
    end
  end

  resources :users do
    member do
      get 'delete'
      get 'draft'
      get 'live'
      get 'closed'
    end
  end

  resource :search, :controller => "search" do
    member do
      get 'results'
    end
  end

  resources :case_studies

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

  resource :oembed, :controller => "oembed"

  resource :session do
    collection do
      get 'logout'
    end
  end

  if Rails.env.development?
    resources :swarm_imports, :controller => 'swarm_import'
  end

  get '/utils/name_to_code', to: 'utils#name_to_code'

  get '/auth/google_oauth2', :as => 'login'
  get '/auth/google_oauth2/callback', to: 'sessions#callback'

  get 'swarms/:swarm_id/graphs/count/:count_field', to: 'graphs#aggregate_count'
  get 'swarms/:swarm_id/graphs/count/:count_field/:unique_field', to: 'graphs#cardinal_count'
  get 'swarms/:swarm_id/graphs/count_over_time/:count_field/:interval', to: 'graphs#count_over_time'
end
