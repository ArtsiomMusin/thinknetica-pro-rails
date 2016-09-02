class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :mark_best]
  before_action :update_answer, only: [:update, :mark_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
  end

  def destroy
    @answer.destroy! if current_user.author_of?(@answer)
  end

  def mark_best
    #@answer.question.answers.each {|a| a.best = false; a.save}
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  private
  def answer_params
    params.require(:answer).permit(:body, :best)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def update_answer
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end
end
