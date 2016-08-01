Rails.application.routes.draw do
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
  resources :users, only: [:index, :show]
end
