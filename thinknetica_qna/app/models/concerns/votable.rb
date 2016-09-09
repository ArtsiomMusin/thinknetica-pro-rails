module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable

    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end

  def vote_rating
    diff = votes.where(positive: true).count - votes.where(positive: false).count
    sprintf('%+d', diff)
  end
end
