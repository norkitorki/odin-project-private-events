class EventsController < ApplicationController
  before_action :set_event, except: %i[ index new create ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :restrict_access_to_host, only: %i[ edit update destroy ]

  def index
    @upcoming_events = Event.upcoming.includes(:host, :attendees).order('start_date')
    @past_events     = Event.previous.includes(:host, :attendees).order('start_date')
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
    if @event.update(event_params)
      redirect_to @event, notice: 'Event has been successfully updated.'
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

  def restrict_access_to_host
    (redirect_to @event, notice: 'You are not allowed to view this page.') if @event.host != current_user
  end
end
