class SearchController < ApplicationController
  def show
    @search_term = params[:s]
    @events = Event.where('LOWER(name) LIKE :s OR LOWER(location) LIKE :s OR LOWER(description) LIKE :s', { s: "%#{@search_term.downcase}%" })
    @users  = User.where('LOWER(username) LIKE ?', "%#{@search_term.downcase}%")
  end
end
