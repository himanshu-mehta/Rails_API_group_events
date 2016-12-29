Rails.application.routes.draw do
  resources :group_events, only: [:index]
  
  resources :users do
  	resources :group_events, except: [:index] 
	member do
	  get 'show_publishable'
	end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
