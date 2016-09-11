class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :vote_yes, :vote_no, :reject_vote, :destroy]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
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

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def vote_yes
    vote(true)
  end

  def vote_no
    vote(false)
  end

  def reject_vote
    unless current_user.author_of?(@question)
      @vote = @question.votes.where(user: current_user).first
      if @vote
        respond_to do |format|
          if @vote.destroy
            format.json { render json: {rating: @question.vote_rating} }
          else
            format.json {
              render json: @vote.errors.full_messages, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  def destroy
    @question.destroy! if current_user.author_of?(@question)
    redirect_to root_path, notice: 'Question removed successfully.'
  end

  private
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :_destroy, :file])
  end

  def vote(positive)
    unless current_user.author_of?(@question)
      @vote = @question.votes.build(positive: positive, user: current_user)
      respond_to do |format|
        if @vote.save
          format.json { render json: {rating: @question.vote_rating} }
        else
          format.json {
            render json: @vote.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end

  def load_question
    @question = Question.find(params[:id])
  end

end
