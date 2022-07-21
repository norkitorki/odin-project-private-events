class EventsController < ApplicationController
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

  def event_params
    params.require(:event).permit(:name, :date, :location, :user_id)
  end
end
