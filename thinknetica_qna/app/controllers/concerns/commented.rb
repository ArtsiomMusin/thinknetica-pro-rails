module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: [:create_comment]
  end

  def create_comment
    @comment = @commentable.comments.build(comment_params)
    if @comment
      respond_to do |format|
        if @comment.save
          PrivatePub.publish_to "/comments/#{params[:controller].classify.downcase}", comment: @comment.to_json
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
     @commentable = params[:controller].classify.constantize.find(params[:id])
   end
end
