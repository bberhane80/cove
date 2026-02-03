class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:edit, :update]

  # GET /users/:id
  def show
    @listings = @user.listings
    @bookmarks = @user.bookmarks.includes(:listing)
  end

  # GET /users/:id/edit
  def edit
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    unless @user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :bio, :avatar)
  end
end
