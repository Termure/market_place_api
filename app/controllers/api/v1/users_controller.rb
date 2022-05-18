class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid,  with: :render_422
  before_action :set_user, only: %i(show update)

    # GET /users/1
  def show
    render json: @user
  end

  # POST /users/1
  def create
    @user = User.new(user_params)
    render_201 if @user.save!
  end

  def update
    if @user.update(user_params)
      render_200
    else
      render_422
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def render_404
    render json: 'Not found', status: :not_found
  end

  def render_422
    render json: @user.errors, status: :unprocessable_entity
  end

  def render_201
    render json: @user, status: :created
  end

  def render_200
    render json: @user, status: :ok
  end
end
