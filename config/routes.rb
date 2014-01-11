Foodie::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
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

  resources :meals, only: [:index, :edit, :update, :show, :new, :create, :destroy] 
  resource :plan, only: [:new, :create, :show] do
    post "/new", to: "plans#create"
    resources :meals, only: [:create]
  end

  get "/today", to: "meals#today", as: :today
  get "/week/:date", to: "meals#week", as: :week
  get "/week/", to: "meals#week", as: :current_week
  get "/next/", to: "meals#next", as: :next

  class CurrentUserConstraint
    def matches? 
      request.cookies.key?("user_token")
    end
  end

  resource :user, use_current_user: true do
    resources :meals, only: [:index]

    get "/week/:date", to: "meals#week", as: :week
    get "/week/", to: "meals#week", as: :current_week

    get "/next/", to: "meals#next", as: :next
  end

  resource :session, only: [:update, :show]

  root to: "meals#index"
end
