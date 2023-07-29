Rails.application.routes.draw do
  post '/reddit_users/get_saved_data', to: 'reddit_users#get_saved_data'
end
