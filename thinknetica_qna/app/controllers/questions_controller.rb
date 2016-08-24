class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
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
    @question = current_user.questions.create(question_params)
    if @question.valid?
      redirect_to @question, notice: 'Your question created successfully.'
    else
      redirect_to new_question_path, notice: 'Could not create a question.'
    end
  end

  def destroy
    @question.destroy
    redirect_to root_path, notice: 'Question removed successfully.'
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    puts "PARAMS #{params.inspect}"
    @question = Question.find(params[:id])
    puts "FOOUND: #{@question.inspect}"
  end

end
