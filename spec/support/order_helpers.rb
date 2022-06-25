module OrderHelpers
  def sum_products_price(order)
    order.products.map(&:price).sum
  end
end
