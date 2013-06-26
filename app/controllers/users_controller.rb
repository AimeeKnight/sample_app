class UsersController < ApplicationController
  before_filter :signed_in_user,    only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,      only: [:edit, :update]
  before_filter :admin_user,        only: :destroy
  before_filter :already_signed_in,  only: [:new, :create]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
      #sign in user as part of successful profile update because remember token gets reset when user saved and invalidates the user’s session
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    unless current_user?(user)
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path, notice: "Admins can't delete themselves"
  end

  private

    def signed_in_user
      unless signed_in? #check if the seesion has a current_user
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    #calls current_user? helper method to check if the sessions current_user matches the user submitting an edit or update action
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def already_signed_in
      if signed_in?
        redirect_to root_path, notice: "Already signed in"
      end
    end
end
