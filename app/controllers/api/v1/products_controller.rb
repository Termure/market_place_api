class Api::V1::ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :set_product, only: [:show]

  def index
    render json: Product.all
  end

  def show
    render json: @product
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :published, :user_id)
  end

  def render_404
    render json: 'Product Not found', status: :not_found
  end
end
