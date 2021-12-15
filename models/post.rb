require 'active_record'
require_relative './feedback'
require_relative './rating'

class Post < ActiveRecord::Base
  validates :title, :content, :user_id, :ip_address, presence: true

  has_many :ratings, dependent: :destroy
  has_many :feedbacks, as: :feedbackable
end
