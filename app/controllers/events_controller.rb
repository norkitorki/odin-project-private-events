class EventsController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :set_event, only: %i[ update add_attendee ]

  def index
    @events = Event.all
  end

  def update
    return add_attendee if params[:commit] == 'Enter'
    return remove_attendee if params[:commit] == 'Leave'

    if @event.update(event_params)
      redirect_to root_path, notice: 'Event has been successfully updated.'
    else
      flash.now[:alert] = 'Event has not been updated.'
      render root_path, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :location, :user_id)
  end

  def add_attendee
    user_id = params[:event][:user_id].to_i
    if @event.attendees.none? { |a| a.id == user_id }
      @event.attendees << User.find(user_id)
      redirect_to root_path, notice: 'You successfully entered an event.'
    else
      redirect_to root_path, notice: 'You already entered this event.'
    end
  end

  def remove_attendee
    @event.attendees.delete(params[:event][:user_id].to_i)
    redirect_to root_path, notice: 'You left an event.'
  end
end
