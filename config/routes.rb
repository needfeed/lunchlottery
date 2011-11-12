LunchLottery::Application.routes.draw do

  root :to => "people#welcome"

  resources :locations, :only => [:new, :create] do
    resources :restaurants, :only => [:new, :create]
  end

  get "people/:token" => "people#update", :as => :person_token
  get ":location" => "people#index", :as => :location
  post "people" => "people#create"

  match ':controller(/:action(/:id(.:format)))' # TODO:KILL ME

end
