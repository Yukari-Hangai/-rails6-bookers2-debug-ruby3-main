Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  
   devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
   resource :favorites, only: [:destroy, :create]
   resources :book_comments, only: [:create, :destroy]
  end
  
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only:[:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  #/users/:user_id/followingsと/users/:user_id/followersに対してはそれぞれrelationships#followingsとrelationships#followersをルーティングする
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end