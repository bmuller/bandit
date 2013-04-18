Bandit::Engine.routes.draw do
  get ':id' => 'dashboard#show', :as => 'bandit'

  root :to => 'dashboard#index'
end
