require 'action_controller'
require_relative '../models/post'
require_relative '../controllers/application_controller'

class PostsController < ApplicationController
  before_action :fetch_post, only: %i[update]

  def index
    @posts = my_posts_filter? ? @current_user.posts : Post.all

    render json: @posts, status: :ok
  end

  def show
    @post = Post.find_by(id: params[:id])

    render json: @post, status: :ok
  end

  def create
    create_and_assign_current_user unless @current_user

    @post = @current_user.posts.new(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render_errors(@post)
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render_errors(@post)
    end
  end


  private

  def post_params
    params.require(:post).permit(:title, :content).merge(ip_address: request.remote_ip)
  end

  def create_and_assign_current_user
    @current_user = User.create(email: "#{SecureRandom.alphanumeric(8)}@umai.com", password: '123123')
  end

  # Filter by current user posts
  def my_posts_filter?
    params[:filter] == 'me'
  end

  def fetch_post
    @post = @current_user.posts.find_by(id: params[:id])

    render_not_found('Post') unless @post
  end
end