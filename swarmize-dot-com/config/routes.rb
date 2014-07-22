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
  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
