require 'action_controller'
require_relative '../models/post'
require_relative '../models/rating'
require_relative '../controllers/application_controller'

class RatingsController < ApplicationController
  before_action :fetch_post, only: %i[create update]
  before_action :fetch_rating, only: %i[update]
  before_action :user_already_rated_the_post?, only: %i[create]

  def create
    @rating = @post.ratings.new(rating_params)

    if @rating.save
      render json: @rating, status: :created
    else
      render_errors(@rating)
    end
  end

  def update
    if @rating.update(rating_params)
      render json: @rating, status: :ok
    else
      render_errors(@rating)
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:rate).merge(user_id: @current_user.id)
  end

  def fetch_post
    @post = Post.find_by(id: params[:post_id])

    render_not_found('Post') unless @post
  end

  def fetch_rating
    @rating = @post.ratings.where(user_id: @current_user.id, id: params[:id])&.first

    render_not_found('Rating') unless @rating
  end

  def user_already_rated_the_post?
    if @post.ratings.find_by(user_id: @current_user.id)
      render json: { errors: ['You already rated this post'] }, status: :forbidden
    end
  end
end