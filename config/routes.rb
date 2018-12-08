Rails.application.routes.draw do

  root to: "games#index"

  get '/games/move', :to => 'games#move'
end
