class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_to, only: :create

  respond_to :json

  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
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

   def channel_name
     if @commentable.instance_of? Question
       id = @commentable.id
     elsif @commentable.instance_of? Answer
       id = @commentable.question.id
     end
     "/questions/#{id}/comments"
   end

   def publish_to
     PrivatePub.publish_to channel_name, comment: @comment.to_json if @comment.valid?
   end
end
