class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = 'Your answer created successfully.'
    else
      flash[:notice] = 'Could not create an answer.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy!
      redirect_to question_path(@answer.question), notice: 'Answer removed successfully.'
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
