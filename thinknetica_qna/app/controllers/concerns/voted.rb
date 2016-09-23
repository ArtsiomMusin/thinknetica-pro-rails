module Voted
  extend ActiveSupport::Concern
  include VotableHelper

  included do
    before_action :load_votable, only: [:vote_yes, :vote_no, :reject_vote]
    before_action :find_vote, only: :reject_vote

    respond_to :json, only: [:vote_yes, :vote_no, :reject_vote]
    authorize_resource
  end

  def vote_yes
    vote(1)
  end

  def vote_no
    vote(-1)
  end

  def reject_vote
    respond_with(@vote.destroy) do |format|
      format.json { render json: { rating: format_rating(@votable.vote_rating), id: @votable.id } }
    end if @vote
  end

  private
   def load_votable
     @votable = params[:controller].classify.constantize.find(params[:id])
   end

   def find_vote
     @vote = current_user.find_vote(@votable)
   end

  def vote(state)
    respond_with(@vote = @votable.votes.create(state: state, user: current_user)) do |format|
      format.json { render json: { rating: format_rating(@votable.vote_rating), id: @votable.id } }
    end unless current_user.author_of?(@votable)
  end
end
