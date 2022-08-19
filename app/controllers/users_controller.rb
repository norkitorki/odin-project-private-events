class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def invitations
    @user = User.find(params[:user_id])
  end
end
