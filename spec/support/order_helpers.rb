module OrderHelpers
  def set_products_price(order, prices, total)
    order.products.each_with_index { |product, index| product.price = prices[index] }
    order.total = total
    order.save
  end

  def sum_products_price(order)
    order.products.map(&:price).sum
  end
end
