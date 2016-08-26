class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question created successfully.'
    else
      flash[:notice] = 'Could not create a question.'
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to root_path, notice: 'Question removed successfully.'
    end
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end

end
