Swarmize::Application.routes.draw do
  root "swarms#index"

  resources :swarms do
    member do
      get 'fields'
      get 'preview'
      get 'embed'
      get 'delete'
      get 'commission'
      post 'update_fields'
      post 'do_commission'
    end
  end

  resources :results do
  end

  get 'results/:swarm_id/graphs/count/:count_field', to: 'graphs#aggregate_count'
  get 'results/:swarm_id/graphs/count/:count_field/:unique_field', to: 'graphs#cardinal_count'
end
