Measurement::Engine.routes.draw do

  resources :steps
  resources :bpms
  resources :heights
  resources :weights
  resources :blood_pressures
  resources :blood_oxygens
  resources :body_fats

end
