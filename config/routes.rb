Rails.application.routes.draw do
  root 'static_pages#home'

  scope '(:locale)' do
    resources :contacts, only: [:create]
    resources :orders, only: [:new, :update, :create, :destroy]
    resources :order_items, only: [:create, :destroy]
    resources :users
    resources :account_activations, only: [:edit, :update]
    resources :password_resets, only: [:edit, :update, :new, :create]
    resources :teams, only: [:new, :create, :edit, :update, :show, :index]
    get 'tournament_main' => 'static_pages#tournament_main'
    get 'tournament_classic' => 'static_pages#tournament_classic'
    get 'tournament_stern' => 'static_pages#tournament_stern'
    get 'tournament_bop' => 'static_pages#tournament_bop'
    get 'tournament_team' => 'static_pages#tournament_team'
    get 'tournament_kids' => 'static_pages#tournament_kids'
    get 'bank_transfer/:id' => 'static_pages#bank_transfer', :as => :bank_transfer
    get 'photos' => 'static_pages#photos'
    get 'signup'    => 'users#new'
    get 'wait_for_sff' => 'static_pages#wait_for_sff'
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'
    resources :tournaments, only: [] do
      member do
        get 'standings'
      end
    end
  end

  scope 'admin' do
    resources :products
    resources :payment_confirmations, only: [:index, :create, :update]
    resources :flippers
    resources :tournaments, only: [:new, :create, :edit, :update, :destroy, :show, :index]
    resources :user_managements, only: [:index, :new, :create, :edit, :update]
    delete 'user_switches' => 'user_switches#destroy', as: 'destroy_user_switches'
    post 'user_switches' => 'user_switches#create', as: 'create_user_switches'
    get 'sff_validations' => 'sff_validations#index'
    scope 'manage/(:tournament_id)' do
      resources :matches
      get 'match_destroy_confirm/:id' => 'match_confirmations#match_destroy', as: 'match_destroy_confirm'
      patch 'match_edit_confirm/:id' => 'match_confirmations#match_edit', as: 'match_edit_confirm'
      post 'match_create_confirm' => 'match_confirmations#match_create', as: 'match_create_confirm'
    end

  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

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
