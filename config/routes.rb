LunchLottery::Application.routes.draw do

  root :to => "people#index"

  get       "people/:token" => "people#edit",   :as => :person_token
  put       "people/:token" => "people#update"
  resources :people, :except => [:edit, :update]

  match ':controller(/:action(/:id(.:format)))'

end
