class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with Question.all, each_serializer: QuestionsAllSerializer
  end

  def show
    respond_with Question.find(params[:id])
  end
end
