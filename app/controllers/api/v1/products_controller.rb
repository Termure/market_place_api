class Api::V1::ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :check_login, only: [:create]
  before_action :check_owner, only: [:update, :destroy]

  def index
    render json: Product.all
  end

  def show
    render_status(@product, :ok)
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render_status(product, :created)
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render_status(@product, :ok)
    else
      render_422
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def render_404
    render json: 'Product Not found', status: :not_found
  end

  def render_422
    render json: @product.errors, status: :unprocessable_entity
  end

  def render_status(product, status)
    render json: product, status: status
  end
end
