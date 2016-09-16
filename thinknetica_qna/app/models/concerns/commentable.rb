module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable
  end

  def build_comment(params)
    comments.build(params)
  end
end
