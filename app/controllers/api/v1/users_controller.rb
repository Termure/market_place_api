class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  # GET /users/1
  def show
    render json: User.find(params[:id])
  end

  # POST /users/1
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def render_404
    render json: 'Not found', status: :not_found
  end
end
