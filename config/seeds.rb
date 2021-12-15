require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/rating'
require_relative '../models/feedback'
require 'faker'

class Seeds
  def self.call
    return if User.all.count > 99

    last_user_id = User.pluck(:id).sort.last
    users = (last_user_id..last_user_id + 100).each_with_object([]) do |i, memo|
      memo << { id: i, email: Faker::Internet.email, password: '123123' }
    end

    users = User.insert_all(users, returning: %w[id email])
    puts 'Users successfully imported'

    last_post_id = Post.pluck(:id).sort.last
    posts = (last_post_id..last_post_id + 20_000).each_with_object([]) do |i, memo|
      memo << {
          id: i, title: Faker::Lorem.sentence(word_count: 6),
          content: Faker::Lorem.paragraph(sentence_count: 3),
          ip_address: ip_address_list.sample,
          user_id: users.pluck('id').sample
      }
    end

    posts = Post.insert_all(posts, returning: %w[id avg_rating])
    puts 'Posts successfully imported'

    last_rating_id = Rating.pluck(:id).sort.last
    ratings = (last_rating_id..last_rating_id + 1000).each_with_object([]) do |i, memo|
      memo << {
          id: i,
          post_id: posts.pluck('id').sample,
          rate: rand(1..5),
          user_id: users.pluck('id').sample
      }
    end

    ratings = Rating.insert_all(ratings, returning: %w[id rate])
    puts 'Ratings successfully imported'

    last_feedback_id = Feedback.pluck(:id).sort.last
    feedbacks = (last_feedback_id..last_feedback_id + 10_000).each_with_object([]) do |i, memo|
      owner = users.pluck('id').sample
      user = users.pluck('id', 'email').sample
      post = posts.pluck('id', 'avg_rating').sample
      memo << {
          id: i,
          owner_id: owner,
          comment: Faker::Lorem.paragraph(sentence_count: 3),
          feedbackable_type: even?(i) ? 'Post' : 'User',
          feedbackable_id: even?(i) ? post[0] : user[0],
          user_email: even?(i) ? nil : user[1],
          post_rating: even?(i) ? post[1] : nil
      }
    end

    feedbacks = Feedback.insert_all(feedbacks)
    puts 'Feedbacks successfully imported'
  end

  def ip_address_list
    @ip_address_list ||= (1..50).map { |_i| Faker::Internet.ip_v4_cidr }
  end
end
