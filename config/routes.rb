Rails.application.routes.draw do
  resources :short_urls, path: '/', except: %w(new update edit)
end
