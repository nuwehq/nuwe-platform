Nu::Engine.routes.draw do

  resources :teams do
    resources :scores
  end

  resources :scores do
    collection do
      get :today
      get :week
    end
  end

end
