Blog::Application.routes.draw do
  resources :users do
    collection do
      get :login
      get :logout
      get :confirm
    end
  end
  
  resources :posts do
    member do
      post :create_comment
    end
  end
  
  root :to => 'posts#index'
end
