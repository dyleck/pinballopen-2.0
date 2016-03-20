Rails.application.routes.draw do

  get 'payment_confirmations/new'

  get 'payment_confirmations/create'

  root 'static_pages#home'
  get '/:locale' => 'static_pages#home'
  scope '(:locale)' do
    resources :orders, only: [:new, :update, :create]
    resources :order_items, only: [:create, :destroy]
    resources :users
    resources :account_activations, only: [:edit, :update]
    resources :password_resets, only: [:edit, :update, :new, :create]
    get 'about'     => 'static_pages#about'
    get 'contact'   => 'static_pages#contact'
    get 'tournament_main' => 'static_pages#tournament_main'
    get 'tournament_classic' => 'static_pages#tournament_classic'
    get 'tournament_stern' => 'static_pages#tournament_stern'
    get 'tournament_bop' => 'static_pages#tournament_bop'
    get 'tournament_team' => 'static_pages#tournament_team'
    get 'tournament_kids' => 'static_pages#tournament_kids'
    get 'bank_transfer' => 'static_pages#bank_transfer'
    get 'signup'    => 'users#new'
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'
  end

  scope 'admin' do
    resources :products
    resources :payment_confirmations, only: [:create, :edit, :update]
    get 'sff_validations' => 'sff_validations#index'
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
