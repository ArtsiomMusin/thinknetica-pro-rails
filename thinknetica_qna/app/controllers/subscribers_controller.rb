class SubscribersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: :create

  respond_to :js

  authorize_resource

  def create
    respond_with(@question.subscribers.create(user_id: current_user.id))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
