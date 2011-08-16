LunchLottery::Application.routes.draw do

  root :to => "people#welcome"

  resources :restaurants
  resources :locations, :only => [:new, :create]

  get "people/:token" => "people#update", :as => :person_token
  get ":location" => "people#index", :as => :location
  post "people" => "people#create"

  match ':controller(/:action(/:id(.:format)))'

end
