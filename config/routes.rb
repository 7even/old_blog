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
  
  get 'archive/:year/:month' => 'posts#archive', constraints: { year: /\d{4}/, month: /\d{1,2}/ }, as: 'archive'
  
  root :to => 'posts#index'
end
