require 'action_dispatch'
require_relative '../controllers/users_controller'
require_relative '../controllers/posts_controller'
require_relative '../controllers/ratings_controller'
require_relative '../controllers/feedbacks_controller'

class Routes
  def initialize
    @router = ActionDispatch::Routing::RouteSet.new
  end

  def call
    UsersController.include(@router.url_helpers)
    PostsController.include(@router.url_helpers)
    RatingsController.include(@router.url_helpers)

    @router.draw do
      resources :users, only: %i[create] do
        collection do
          post :login
        end

        resources :feedbacks, only: %i[index create update]
      end

      resources :posts, only: %i[index show create update] do
        resources :ratings, only: %i[create update]
        resources :feedbacks, only: %i[index create update]
      end
    end

    @router
  end
end
