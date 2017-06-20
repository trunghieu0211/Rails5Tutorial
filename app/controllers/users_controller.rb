class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :load_user, except: [:new, :index, :create]
  before_action :verify_admin, only: :destroy

  def index
    @microposts = @user.microposts.feed_sort.page(params[:page]).
      per_page Settings.feed.number_feed
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_path
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_user"
      redirect_to users_url
    else
      flash.now[:alert] = t ".delete_failed"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
     @user = User.find_by id: params[:id]

    return if @user
    render file: "public/404.html", status: :not_found, layout: false
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".login_error"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user.is_admin?
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end
end
