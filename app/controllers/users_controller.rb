class UsersController < ApplicationController
  before_action :authenticate_user!, only: :invitations

  def show
    @user = User.find(params[:id])
  end

  def invitations
    @invitations = current_user.invitations.includes(:event)
  end
end
