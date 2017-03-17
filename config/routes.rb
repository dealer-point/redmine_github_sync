# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html


Rails.application.routes.draw do

  match 'pull_requests', :to => 'pull_requests#index', via: [:get, :post]
  post 'payload', :to => 'pull_requests#hooks'
  get 'payload', :to => 'pull_requests#get_hooks'
end

