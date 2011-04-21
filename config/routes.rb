LunchLottery::Application.routes.draw do

  resources :people, :only => [:index, :create]
  get       "people/:token" => "people#show", :as => :person_token

  root :to => "people#index"
end
