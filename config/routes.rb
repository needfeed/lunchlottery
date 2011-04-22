LunchLottery::Application.routes.draw do

  get       "people/:token" => "people#edit",   :as => :person_token
  put       "people/:token" => "people#update"
  resources :people, :except => [:edit, :update]

  root :to => "people#index"
end
