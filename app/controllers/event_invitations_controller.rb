class EventInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, except: %i[ show update ]

  def show
    @user = User.find(params[:id])
    @invitations = @user.invitations.pending.includes(:event)
  end
  
  def new
    @invitation = EventInvitation.new
  end

  def create
    @invitation = @event.event_invitations.new
    @user = find_user(params[:event_invitation][:name_or_email])
    @invitation.user = @user
    
    if @invitation.valid? && user_inviteable?
      @invitation.save
      redirect_to new_event_event_invitation_path, notice: "#{@user.username} has been invited."
    else
      flash.now[:alert] = "User cannot be invited."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @invitation = EventInvitation.find(params[:id])
    if params[:commit] == 'Accept'
      @invitation.event.attendees << @invitation.user
      notice = 'You have accepted the invitation.'
    else
      notice = 'You have rejected the invitation.'
    end
    @invitation.destroy
    redirect_to user_invitations_path(@invitation.user), notice: notice
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def find_user(name_or_email)
    User.find_by('email = :s OR username = :s', { s: name_or_email })
  end

  def user_inviteable?
    @event.host != @user &&
      %i[ attendees invited_users ].none? { |m| @event.send(m).include?(@user) }
  end 
end
