class SearchController < ApplicationController
  def show
    @search_term = params[:s]
  end
end
