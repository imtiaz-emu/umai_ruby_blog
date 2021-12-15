require 'active_record'
require_relative './post'
require_relative './user'

class Rating < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  validates :rate, :post_id, :user_id, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  after_save :update_post_avg_rating

  def as_json_attr
    attributes.merge(post_rating: post.avg_rating)
  end

  private

  def update_post_avg_rating
    post.update_column(:avg_rating, post.ratings.average(:rate).round(1))
  end
end
