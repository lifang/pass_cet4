PassCet4::Application.routes.draw do

  resources :tencents do
    collection do
      get :qqzone_index
    end
  end

  resources :images
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  match '/renren' => 'percents#renren'
  match '/renren6' => 'percents#renren6'
  match '/renren8' => 'percents#renren8'
  match '/sina' => 'percents#sina'
  match '/apps_more' => 'percents#apps_more'

   resources :percents do
     collection do
       get :check,:guanzhu, :questions, :result,:renren_url_generate6,:check6
       get :renren,:renren_url_generate,:renren_like,:close_window,:renren6,:renren8
       get :sina,:next_step,:next_upload,:questions
       post :add_idol
       post :send_message
     end
   end
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'percents#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
