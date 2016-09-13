module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable
  end

  def vote_rating
    sprintf('%+d', votes.sum(:state))
  end

  def build_vote(params)
    votes.build(params)
  end
end
