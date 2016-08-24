class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, expect: [:new]
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: 'Your answer created successfully.'
    else
      redirect_to new_question_answer_path(@question), notice: 'Could not create an answer.'
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    redirect_to @question, notice: 'Answer removed successfully.'
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
