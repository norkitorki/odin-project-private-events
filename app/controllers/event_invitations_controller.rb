class EventInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def index
    @invited_users = @event.invited_users
  end
  
  def new
    @invitation = @event.event_invitations.new
  end

  def create
    @invitation = @event.event_invitations.new
    @user = find_user(params[:event_invitation][:name_or_email])
    @invitation.user = @user
    
    if @invitation.valid? && user_inviteable?
      @invitation.save
      redirect_to new_event_invitation_path, notice: "#{@user.username} has been invited."
    else
      flash.now[:alert] = "User was not invited."
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
    path = params[:commit] == 'Revoke Invitation' ? event_invitations_path(@event) : user_invitations_path(@invitation.user)
    redirect_to path, notice: notice
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
