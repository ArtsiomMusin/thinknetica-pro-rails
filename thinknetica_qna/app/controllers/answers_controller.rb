class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_user, expect: [:new]
  before_action :load_question, expect: [:new]
  before_action :load_answer, only: [:show, :destroy]
  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = @user.id
    if @answer.save
      redirect_to @question, notice: 'Your answer created successfully.'
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question, notice: 'Answer removed successfully.'
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_user
    @user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
  end

  def load_question
    @question = @user.questions.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end
end
