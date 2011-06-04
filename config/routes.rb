Blog::Application.routes.draw do
  resources :users
  match 'login' => 'users#login'
  get 'logout'  => 'users#logout'
  get 'confirm' => 'users#confirm'
  
  resources :posts do
    member do
      post :create_comment
    end
  end
  
  root :to => 'posts#index'
end
