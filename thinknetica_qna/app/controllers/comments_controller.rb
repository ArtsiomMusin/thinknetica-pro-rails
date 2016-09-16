class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  def create
    @comment = @commentable.build_comment(comment_params)
    if @comment
      respond_to do |format|
        if @comment.save
          PrivatePub.publish_to "/comments/#{@commentable.class.to_s.downcase}", comment: @comment.to_json
          format.json { render json: @comment }
        else
          format.json do
            render json: @comment.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

   def load_commentable
     if params[:question_id]
       @commentable = Question.find(params[:question_id])
     elsif params[:answer_id]
       @commentable = Answer.find(params[:answer_id])
     end
     #@commentable = params[:controller].classify.constantize.find(params[:id])
   end
end
