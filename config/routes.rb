LunchLottery::Application.routes.draw do

  root :to => "people#index"

  get       "people/:token" => "people#update",   :as => :person_token
  resources :people, :except => [:edit, :update]

  match ':controller(/:action(/:id(.:format)))'

end
