class EventsController < ApplicationController
  before_action :set_event, except: %i[ index new create ]
  before_action :authenticate_user!, except: %i[ index show ]

  def index
    @events = Event.all
  end

  def show
  end

  def edit
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Event has been successfully created.'
    else
      flash.now[:alert] = 'Event has not been created.'
      render :new, status: :unprocessable_entity
    end
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

  def destroy
    @event.destroy
    redirect_to root_path, alert: 'Event has been destroyed.'
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
