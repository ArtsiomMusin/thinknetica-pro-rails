module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_yes, :vote_no, :reject_vote]
  end

  def vote_yes
    vote(true)
  end

  def vote_no
    vote(false)
  end

  def reject_vote
    unless current_user.author_of?(@votable)
      @vote = @votable.votes.where(user: current_user).first
      if @vote
        respond_to do |format|
          if @vote.destroy
            format.json { render json: { rating: @votable.vote_rating, id: @votable.id } }
          else
            format.json {
              render json: @vote.errors.full_messages, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  private
   def load_votable
     @votable = params[:controller].classify.constantize.find(params[:id])
   end

  def vote(positive)
    unless current_user.author_of?(@votable)
      @vote = @votable.votes.build(positive: positive, user: current_user)
      respond_to do |format|
        if @vote.save
          format.json { render json: { rating: @votable.vote_rating, id: @votable.id } }
        else
          format.json {
            render json: @vote.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end

end
