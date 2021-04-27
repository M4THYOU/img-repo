Rails.application.routes.draw do
    root "image_rows#index"
    resources :image_rows
end
