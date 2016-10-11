class SearchesController < ApplicationController
  respond_to :js

  authorize_resource class: false

  def show
    @results = []
    search = params[:search]
    text = ThinkingSphinx::Query.escape search[:text]
    %w(questions answers comments users).each do |filter|
      @results += filter.classify.constantize.search(text).to_a if search[filter.to_sym]
    end
    @results = ThinkingSphinx.search(text) if @result.blank?
    respond_with @results
  end
end
