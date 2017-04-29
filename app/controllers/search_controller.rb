class SearchController < ApplicationController
  def index
    @source = params[:source]
    @source == 'Everyware' ? @results = ThinkingSphinx.search(params[:query]) : @results = @source.classify.constantize.search(params[:query])
  end
end
