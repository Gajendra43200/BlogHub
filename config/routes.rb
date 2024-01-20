Rails.application.routes.draw do
  # resources :authors
  # post 'login', to: 'authentication#login'

  get '/login', to: 'users#login'
  post '/login', to: 'users#authenticate'
  delete '/logout', to: 'users#logout'

  resources :blogs

  resources :authors do
    resources :blogs
  end
  # config/routes.rb
  get '/block/:id', to: 'admins#block_user', as: :block_user
  post '/block/:id', to: 'admins#block_user'
  get '/unblock/:id', to: 'admins#unblock_user', as: :unblock_user
  post '/unblock/:id', to: 'admins#unblock_user' 

  get 'approve_comments', to: 'admins#all_comments' 
  get 'approval_comments', to: 'super_admins#all_comments'

  get '/approve_comment_by_super_admin/:id', to: 'super_admins#approve_comment_by_super_admin', as: :approve_comment_by_super_admin
  post '/approve_comment_by_super_admin/:id', to: 'super_admins#approve_comment_by_super_admin'

  get '/approve/:id',  to: "admins#approve_comment" , as: :approve
  post 'approve/:id', to: "admins#approve_comment"

    resources :users do
      resources :authors, only: [:show, :index] do
        resources :comments, only: [:new,:create, :destroy, :show, :index]
      end

      resources :blogs, only: [:show, :index] do
        resources :comments, only: [:new,:create, :destroy, :show, :index]
      end
    end
  resources :admins do
    resources :authors, only: [:show, :index] do
      resources :comments, only: [:new,:create, :destroy, :show, :index]
    end
    resources :blogs, only: [:show, :index] do
      resources :comments, only: [:new,:create, :destroy, :show, :index]
    end
  end
  resources :super_admins do
    resources :authors, only: [:show, :index] do
      resources :comments, only: [:new,:create, :destroy, :show, :index]
    end
    resources :blogs, only: [:show, :index] do
      resources :comments, only: [:new,:create, :destroy, :show, :index]
    end
  end

  resources :comments
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"
end
