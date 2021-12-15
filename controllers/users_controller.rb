require 'action_controller'
require_relative '../models/user'
require_relative '../controllers/application_controller'

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[login create]

  def index
    @users = User.all

    render json: @users, status: :ok
  end

  def login
    user = User.find_by(email: params[:email], password: params[:password])

    if user.present?
      render json: {
        message: 'Login successful',
        user_id: user.id
      }, status: :accepted
    else
      render json: { errors: ['User not found'] }, status: :forbidden
    end
  end

  def create
    @user = User.new(email: params['email'], password: params['password'])

    if @user.save
      render json: @user, status: :created
    else
      render_errors(@user)
    end
  end
end