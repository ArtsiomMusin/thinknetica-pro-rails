class SearchesController < ApplicationController
  respond_to :js

  #authorize_resource

  def show
    respond_with(@results = Question.search(params[:text]))
  end
end
