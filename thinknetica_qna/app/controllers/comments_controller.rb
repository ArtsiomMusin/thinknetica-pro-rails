class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  def create
    @comment = @commentable.build_comment(comment_params)
    respond_to do |format|
      if @comment.save
        PrivatePub.publish_to "/#{@commentable.class.to_s.downcase}s/#{@commentable.id}/comments", comment: @comment.to_json
        format.json { render json: @comment }
      else
        format.json do
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

   def load_commentable
     request.path =~ /^\/(\w+)s/
     model_name = Regexp.last_match(1)
     @commentable = model_name.classify.constantize.find(params["#{model_name}_id".to_sym])
   end
end
