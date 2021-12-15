require 'action_controller'
require_relative '../models/user'

class ApplicationController < ActionController::Base
  before_action :authenticate_user

  private

  def authenticate_user
    id = request.headers['HTTP_USER_TOKEN']
    user = User.find_by(id: id)

    if user.present? || create_post?
      @current_user = user
      return true
    end

    render json: { errors: ['Unauthorized'] }, status: :unauthorized
  end

  def create_post?
    params[:controller] == 'posts' && params[:action] == 'create'
  end

  def render_not_found(klass_name)
    render json: { errors: ["#{klass_name} not Found"] }, status: :unprocessable_entity
  end

  def render_errors(object)
    render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
  end
end