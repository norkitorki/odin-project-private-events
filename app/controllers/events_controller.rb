class EventsController < ApplicationController
  before_action :set_event, except: %i[ index new create ]
  before_action :authenticate_user!, except: %i[ index show ]

  def index
    @events = Event.includes(:host, :attendees)
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
    return add_or_remove_attendee(params[:commit]) if %w[ Register Unregister ].any?(params[:commit])

    if @event.update(event_params)
      redirect_to root_path, notice: 'Event has been successfully updated.'
    else
      flash.now[:alert] = 'Event has not been updated.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to root_path, alert: 'Event has been destroyed.'
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_date, :end_date)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def add_or_remove_attendee(action)
    if action == 'Register'
      if !@event.attendees.include?(current_user)
        @event.attendees << current_user
        notice = 'You successfully registered for an event.'
      else
        notice = 'You are already registered for this event.'
      end
    else
      @event.attendees.delete(current_user.id)
      notice = 'You successfully unregistered from an event.'
    end
    redirect_to @event, notice: notice
  end
end
