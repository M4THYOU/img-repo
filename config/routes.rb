Rails.application.routes.draw do
    root "image_rows#index"
    resources :image_rows

    post 'bulk_action', to: 'image_rows#bulk_action'
end
