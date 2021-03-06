class UsersController < ApplicationController
  before_filter :signed_in_user,    only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,      only: [:edit, :update]
  before_filter :admin_user,        only: :destroy
  before_filter :already_signed_in,  only: [:new, :create]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    #paginate takes a hash argument with key :page and value equal to the page requested. User.paginate pulls the users out of the database one chunk at a time (30 by default), based on the :page parameter
    #clicking next buttons will invoke another show view.
    @microposts = @user.microposts.paginate(page: params[:page])
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
    # unless current_user?(user) || user.admin?
    unless current_user?(user)
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path, notice: "Admins can't delete themselves"
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
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
