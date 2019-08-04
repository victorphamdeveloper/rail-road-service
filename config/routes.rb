Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'find_routes' => 'routes#find_routes'
  get 'find_routes_bonus' => 'routes#find_routes_bonus'
end
