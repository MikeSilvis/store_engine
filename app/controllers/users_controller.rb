class UsersController < ApplicationController
  before_filter :require_admin, :only => [:destroy]
  before_filter :require_not_logged_in, :only => [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    edit_personal
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.active = 0
    @user.save()
    redirect_to users_path
  end

  private 

  def edit_personal
    if current_user == false
      redirect_to '/login', :notice => "Please login"
    elsif current_user && current_user.id != params[:id]
      redirect_to root_url, :notice => "You can only edit yourself"
    end
  end

end