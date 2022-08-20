class AttendeesController < ApplicationController
  before_action :set_event
  before_action :authenticate_user!, except: %i[ index ]

  def index
  end

  def create
    if @event.attendees.include?(current_user)
      notice = 'You are already registered for this event.'
    else
      @event.attendees << current_user
      notice = 'You successfully registered for this event.'
    end
    redirect_to @event, notice: notice
  end

  def destroy
    @event.attendees.destroy(current_user)
    redirect_to @event, alert: 'You successfully unregistered from this event.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
