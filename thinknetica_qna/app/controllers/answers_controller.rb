class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :mark_best]

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    # respond_to do |format|
    #   if @answer.save
    #     format.json { render json: @answer }
    #   else
    #     format.json {
    #       render json: @answer.errors.full_messages, status: :unprocessable_entity }
    #   end
    # end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy! if current_user.author_of?(@answer)
  end

  def mark_best
    @question = @answer.question
    @answer.make_best if current_user.author_of?(@question)
  end

  private
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
