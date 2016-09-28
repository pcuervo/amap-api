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
      resources :users, :only => [:index, :show, :create, :update] do
        collection do
          post 'update',              :action => 'update'
          post 'send_password_reset', :action => 'send_password_reset'
          post 'reset_password',      :action => 'reset_password'
        end
      end
      resources :agencies, :only => [:index, :show, :create, :update] do
        collection do
          post 'update',                      :action => 'update'
          post 'add_skills',                  :action => 'add_skills'
          post 'add_criteria',                :action => 'add_criteria'
          post 'add_exclusivity_brands',      :action => 'add_exclusivity_brands'
          post 'remove_exclusivity_brands',   :action => 'remove_exclusivity_brands'
        end
      end
      resources :new_user_requests, :only => [:index, :create, :show] do
        collection do
          post 'confirm_request', :action => 'confirm_request'
          post 'reject_request',  :action => 'reject_request'
          get 'agency_users',     :action => 'agency_users'
          get 'brand_users',      :action => 'brand_users'
        end
      end
      resources :sessions, :only => [:create, :destroy] do
        collection do
          post 'destroy/', :action => 'destroy'
        end
      end
      resources :success_cases, :only => [:index, :create, :show] do
        collection do
          post 'update/', :action => 'update'
          post 'destroy/', :action => 'destroy'
        end
      end
      resources :skill_categories, :only => [:create, :show, :index]
      resources :skills, :only => [:create, :show, :index]
      resources :companies, :only => [:create, :show, :index]
      resources :brands, :only => [:create, :show, :index] do
        collection do
          get 'by_company/:id', :action => 'by_company'
        end
      end
      resources :pitches, :only => [:index, :show, :create, :update] do 
        collection do
          get 'by_brand/:id', :action => 'by_brand'
        end
      end
      resources :pitch_evaluations, :only => [:create, :update] do 
        collection do
          post 'by_user/', :action => 'by_user'
        end
      end
      resources :criteria, :only => [:index]
    end
  end

end
