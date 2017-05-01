class SearchController < ApplicationController
  def index
    @results = Search.find(params[:source], params[:query])
  end
end
