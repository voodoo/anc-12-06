class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :upvoted_posts, through: :votes, source: :post

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
