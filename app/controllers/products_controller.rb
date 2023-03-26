class ProductsController < ApplicationController
  before_action :set_product_class

  def index
    data = load_products
    response_with_objects(data, data.count)
  end

  private

  def load_products
    @product_class.all
  end

  def set_product_class
    @product_class = Objects.tolgeo_model_class(params['tolgeo'], 'product')
  end
end

