class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }

  default_scope { order(created_at: :desc) }
end
