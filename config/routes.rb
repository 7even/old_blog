Blog::Application.routes.draw do
  resources :users
  match 'login'         => 'users#login'
  get 'logout'          => 'users#logout'
  get 'confirm/:token'  => 'users#confirm'
  
  resources :posts do
    member do
      post :create_comment
      delete 'destroy_comment/:id' => 'posts#destroy_comment', as: 'destroy_comment'
    end
  end
  
  root :to => 'posts#index'
end
