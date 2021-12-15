require 'active_record'
require_relative './feedback'
require_relative './post'

class User < ActiveRecord::Base
  validates :email, :password, presence: true

  has_many :feedbacks, as: :feedbackable
  has_many :posts, dependent: :destroy
  has_many :my_feedbacks, class_name: 'User', foreign_key: :owner_id
end
