require 'active_record'
require_relative './user'

class Feedback < ActiveRecord::Base
  validates :comment, :owner_id, presence: true

  belongs_to :feedbackable, polymorphic: true
  belongs_to :owner, class_name: 'User', optional: true
end
