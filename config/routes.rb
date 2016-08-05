Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # scope module: 'api' do
  #   namespace :v1 do
  #     resources :users, :only => [:index] 
  #   end
  # end

  namespace :api do
    scope module: :v1 do
      resources :users, :only => [:index, :show, :create, :update, :destroy] 
      resources :agencies, :only => [:index, :show, :create, :update, :destroy] 
      resources :new_user_requests, :only => [:index, :create] 
      resources :sessions, :only => [:create, :destroy] do
        collection do
          post 'destroy/', :action => 'destroy'
        end
      end
    end
  end
end
