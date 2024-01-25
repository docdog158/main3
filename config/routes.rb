Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about",to: "homes#about"
  
  # 検索機能の実装 
  get "/search" => "searches#search"
  #ここまで
  
  devise_for :users

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
  
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
    
  end
  
  # フォロー/フォロワー機能の実装 %>
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  	get "followings" => "relationships#followings", as: "followings"
  	get "followers" => "relationships#followers", as: "followers"
    
    #投稿数の差
    get "search" => "users#search"
    #end
    
  end
  #ここまで
  
  
  #chat
  resources :chats, only: [:show, :create, :destroy]
  #end
  
  
  #group
  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    #上のdo＋下のendまで
    resource :group_users, only: [:create, :destroy]
    #追加・メール機能  
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
      
    end
  #end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
