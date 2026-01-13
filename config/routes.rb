Rails.application.routes.draw do
  root "campaigns#index"
  
  resources :campaigns do
    member do
      post :dispatch_campaign
    end
  end
  
  resources :recipients, only: [] do
    member do
      patch :update_status
    end
  end
end

