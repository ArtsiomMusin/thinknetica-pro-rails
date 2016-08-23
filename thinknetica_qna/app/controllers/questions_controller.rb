class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_user, only: [:create, :destroy]
  before_action :load_question, only: [:show, :destroy]
  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = @user.questions.create(question_params)
    if @question.valid?
      redirect_to @question, notice: 'Your question created successfully.'
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to root_url, notice: 'Question removed successfully.'
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def load_user
    @user = User.find(params[:user_id])
  end
end
