class SearchesController < ApplicationController
  respond_to :js

  authorize_resource class: false

  def show
    @results = []
    text = ThinkingSphinx::Query.escape params[:text]
    %w(questions answers comments users).each do |filter|
      @results.push(filter.classify.constantize.search(text)) if params[filter.to_sym]
    end
    @results = ThinkingSphinx.search(params[:text]) if @result.blank?
    respond_with @results
  end
end
