module Votable
  extend ActiveSupport::Concern
  include HasVotes

  def vote_rating
    diff = votes.where(positive: true).count - votes.where(positive: false).count
    sprintf('%+d', diff)
  end
end
