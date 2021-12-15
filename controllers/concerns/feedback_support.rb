require 'active_support'

module FeedbackSupport
  extend ActiveSupport::Concern

  included do
    before_action :fetch_feedbackable
    before_action :fetch_feedback, only: %i[update]
  end

  # GET
  # /posts/:post_id/feedbacks
  # /users/:user_id/feedbacks
  def index
    render json: @feedbackable.feedbacks, status: :ok
  end

  # POST
  # /posts/:post_id/feedbacks
  # /users/:user_id/feedbacks
  def create
    @feedback = @feedbackable.feedbacks.new(@feedback_params)

    if @feedback.save
      render json: @feedback, status: :created
    else
      render_errors(@feedback)
    end
  end

  # PATCH
  # /posts/:post_id/feedbacks/:id/
  # /users/:user_id/feedbacks/:id/
  def update
    if @feedback.update(@feedback_params)
      render json: @feedback, status: :ok
    else
      render_errors(@feedback)
    end
  end

  private

  # Feedback can be either for User or Post
  def fetch_feedbackable
    case
    when params[:post_id].present?
      fetch_post
    when params[:user_id].present?
      fetch_user
    end
  end

  def fetch_feedback
    @feedback = @feedbackable.feedbacks.find_by(id: params[:id])

    render_not_found('Feedback') unless @feedback
  end

  # @feedback_params will include post rating if feedback is for a Post,
  # to support the de-normalization of records to faster access
  def fetch_post
    @feedbackable = Post.find_by(id: params[:post_id])

    unless params[:action] == 'index'
      @feedback_params = feedback_params.merge(post_rating: @feedbackable&.avg_rating)
    end

    render_not_found('Post') unless @feedbackable
  end

  # @feedback_params will include user email if feedback is for a User,
  # to support the de-normalization of records to faster access
  def fetch_user
    @feedbackable = User.find_by(id: params[:user_id])

    unless params[:action] == 'index'
      @feedback_params = feedback_params.merge(user_email: @feedbackable&.email)
    end

    render_not_found('User') unless @feedbackable
  end

  def feedback_params
    params.require(:feedback).permit(:comment).merge(owner_id: @current_user.id)
  end
end