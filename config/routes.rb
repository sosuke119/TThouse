Rails.application.routes.draw do
  
  resources :chatrooms
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Facebook::Messenger::Server, at: 'bot'
  mount ActionCable.server, at: '/cable'


  devise_for :users, controllers: { 
    omniauth_callbacks: "users/omniauth_callbacks" ,
    sessions: 'users/sessions'
  }
    # linebot
  post 'callback' => 'line#callback'


  resources :sessions do 
    member do 
      
    end
    collection do 
      patch :finish_handover_chat
      patch :handover_chat
      patch :finish_conversation
    end
  end
  resources :chatrooms
  resources :message_logs, only: [:show] do 
    collection do 
      get :deliver
    end
  end


  case Rails.env
  when 'development'

    get  :import_properties_page, controller: :import
    get  :import_properties_page_two, controller: :import
    post :import_properties, controller: :import
    post :import_properties_two, controller: :import

    root to: 'import#import_properties_page'
    
  else
    root to: 'visitor#welcome'
  end

  get :policy, controller: :visitor

  get '/robots.txt', :to => redirect('/public/robots.txt')
  
end
