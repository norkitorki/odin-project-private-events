class EventsController < ApplicationController
  def index
    @events = Event.all.includes(:event_visitors)
  end
end
