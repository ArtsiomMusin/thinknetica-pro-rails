class Search < ApplicationRecord
  def self.seach_results(search_params)
    results = []
    text = ThinkingSphinx::Query.escape search_params[:text]
    %w(questions answers comments users).each do |filter|
      results += filter.classify.constantize.search(text).to_a if search_params[filter.to_sym]
    end
    results = ThinkingSphinx.search(text) if results.blank?
    results
  end
end
