class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :subscribe]
  before_action :create_answer, only: :show
  after_action :publish_question, only: :create

  include Voted
  respond_to :js, only: :update
  respond_to :json, only: :subscribe

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy!, location: root_path)
  end

  def subscribe
    binding.pry
    respond_with(@question.subscribers.create(user_id: current_user.id))
  end

  private
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :_destroy, :file])
  end

  def create_answer
    @answer = Answer.new
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end
end
