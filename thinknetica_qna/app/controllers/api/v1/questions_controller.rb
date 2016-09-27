class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @uestions = Question.all
    respond_with @uestions
  end
end
