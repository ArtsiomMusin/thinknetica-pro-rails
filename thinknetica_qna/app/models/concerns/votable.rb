module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable
  end

  def vote_rating
    diff = votes.where(positive: true).count - votes.where(positive: false).count
    sprintf('%+d', diff)
  end

  def build_vote(params)
    votes.build(params)
  end
end
