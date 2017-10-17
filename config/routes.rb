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
          get 'admin',                :action => 'admin'
          post 'destroy',              :action => 'destroy'
        end
      end
      resources :agencies, :only => [:index, :show, :create, :update] do
        collection do
          post 'update',                      :action => 'update'
          post 'add_skills',                  :action => 'add_skills'
          post 'add_criteria',                :action => 'add_criteria'
          post 'add_exclusivity_brands',      :action => 'add_exclusivity_brands'
          post 'remove_exclusivity_brands',   :action => 'remove_exclusivity_brands'
          post 'search',                      :action => 'search'
          post 'directory',                   :action => 'directory'
          post 'get_users',                   :action => 'get_users'
          get 'get_recommendations/:id',      :action => 'get_recommendations'
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
          post 'is_active', :action => 'is_active'
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
      resources :companies, :only => [:create, :show, :index] do 
        collection do 
          post 'update',                  :action => 'update'
          post 'add_favorite_agency',     :action => 'add_favorite_agency'
          post 'remove_favorite_agency',  :action => 'remove_favorite_agency'
          post 'get_users',               :action => 'get_users'
          post 'get_pitches',             :action => 'get_pitches'
          post 'unify',                   :action => 'unify'
        end
      end
      resources :brands, :only => [:create, :show, :index] do
        collection do
          get 'by_company/:id', :action => 'by_company'
          post 'unify',         :action => 'unify'
        end
      end
      resources :pitches, :only => [:index, :show, :create, :update] do 
        collection do
          get 'by_brand/:id', :action => 'by_brand'
          get 'stats/:id',    :action => 'stats'
          post 'merge',       :action => 'merge'
        end
      end
      resources :pitch_evaluations, :only => [:create, :show] do 
        collection do
          post 'by_user/',  :action => 'by_user'
          post 'update',    :action => 'update'
          post 'cancel',    :action => 'cancel'
          post 'decline',   :action => 'decline'
          post 'archive',   :action => 'archive'
          post 'activate',  :action => 'activate'
          post 'destroy',   :action => 'destroy'
          post 'search',    :action => 'search'
          post 'filter',    :action => 'filter'
          post 'average_per_month_by_user',   :action => 'average_per_month_by_user'
          post 'average_per_month_by_brand',  :action => 'average_per_month_by_brand'
          post 'average_per_month_by_agency', :action => 'average_per_month_by_agency'
          post 'average_per_month_by_company', :action => 'average_per_month_by_company'
          post 'average_per_month_industry',  :action => 'average_per_month_industry'
          post 'dashboard_summary_by_agency', :action => 'dashboard_summary_by_agency'
          post 'dashboard_summary_by_user',   :action => 'dashboard_summary_by_user'
          post 'dashboard_summary_by_client', :action => 'dashboard_summary_by_client'
          post 'dashboard_summary_by_brand',  :action => 'dashboard_summary_by_brand'
        end
      end
      resources :criteria, :only => [:index]
      resources :pitch_results, :only => [:show, :create, :update] do
        collection do
          post 'update', :action => 'update'
        end
      end
      resources :pitch_winner_surveys, :only => [:create, :show] do 
        collection do 
          post 'update', :action => 'update'
        end
      end
      resources :dashboards do
        collection do
          get 'amap', :action => 'amap'
        end
      end
    end
  end

end
