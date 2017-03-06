Rails.application.routes.draw do
  resources :friend_requests, except: [:new, :edit]
  resources :friendships, except: [:new, :edit, :update]
  resources :attendances, except: [:new, :edit]
  resources :trips, except: [:new, :edit]
  resources :cities, except: [:new, :edit]
  resources :attraction_suggestions, except: [:new, :edit]
  resources :user_attractions, except: [:new, :edit]
  resources :user_tags, except: [:new, :edit]
  resources :attraction_tags, except: [:new, :edit]
  resources :tags, except: [:new, :edit]
  resources :attractions, except: [:new, :edit]
  resources :examples, except: [:new, :edit]
  post '/sign-up' => 'users#signup'
  post '/sign-in' => 'users#signin'
  delete '/sign-out/:id' => 'users#signout'
  patch '/change-password/:id' => 'users#changepw'
  resources :users, except: [:new, :edit]
end
