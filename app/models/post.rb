class Post < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :content, presence: true, length: { minimum: 10 }

  def upvote_count
    votes.count
  end

  def ranking_score
    # Get the number of votes
    vote_count = votes.count
    
    # Calculate hours since post creation
    hours_age = ((Time.current - created_at) / 1.hour).round
    
    # Base score is the number of votes
    score = vote_count
    
    # Apply time decay factor (24-hour period)
    # Score reduces by ~63% after 24 hours (using exponential decay)
    time_decay = Math.exp(-hours_age / 24.0)
    
    # Final score combines votes with time decay
    (score * time_decay).round(6)
  end

  # Scope for getting ranked posts
  scope :ranked, -> {
    # First, get all posts with their vote counts
    posts_with_votes = left_joins(:votes)
      .select('posts.*, COUNT(votes.id) as vote_count')
      .group('posts.id')
      .to_a

    # Then sort them using Ruby's sort_by with our ranking algorithm
    sorted_posts = posts_with_votes.sort_by do |post|
      hours_age = ((Time.current - post.created_at) / 1.hour).round
      vote_count = post.vote_count
      
      # Calculate ranking score (negative for DESC order)
      -1 * (vote_count * Math.exp(-hours_age / 24.0))
    end

    # Convert back to ActiveRecord::Relation
    # Create a CASE statement for ordering based on the sorted IDs
    order_clause = sorted_posts.map.with_index do |post, index|
      "WHEN id = #{post.id} THEN #{index}"
    end.join(' ')

    where(id: sorted_posts.map(&:id))
      .order(Arel.sql("CASE #{order_clause} END"))
  }
end
