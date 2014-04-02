Rails.application.routes.draw do
	mount API::Base => '/api'
  devise_for :users
  use_doorkeeper
end
