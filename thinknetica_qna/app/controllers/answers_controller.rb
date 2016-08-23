class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:index, :show, :create]
  def index
    @answers = @question.answers
  end

  def show
    @answer = @question.answers.find(params[:id])
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.valid?
      redirect_to @question, notice: 'Your answer created successfully.'
    else
      render :new
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
