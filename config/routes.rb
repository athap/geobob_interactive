Geobob::Application.routes.draw do
  
  root :to => 'default#index'
  
  # top level pages
  match '/contact' => 'default#contact', :as => :contact
  match '/sitemap' => 'default#sitemap', :as => :sitemap
  match '/ping' => 'default#ping', :as => :ping
  match '/about' => 'default#about', :as => :about
  match '/demos' => 'default#demos', :as => :demos
  
  match 'admin' => 'admin/dashboard#index'
  
  devise_for :users
  
  namespace "admin" do
    resources :users
  end
  
  resources :facts
  resources :projects do
    resources :facts do
      post :sort, :on => :collection
    end
    collection do
      get :details
      post :details
    end
    member do
      get :export
      get :details
      post :details
      put :details
      get :content
      get :build
      get :icons
    end
  end
  resources :app_links
  resources :app_feeds
  resources :app_maps

end



