class ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  before_action :check_category, only: %i[create]

  def index
    products = Product.all
    render json: products
  end

  def create
    category = Category.find_by(name: params[:category])
    product = category.products.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def show
    product = Product.find(params[:id])
    render json: product
  end

  def update
    product = Product.find(params[:id])

    if product.update(product_params)
      render json: product, status: :ok
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    render json: 'Product deleted', status: :ok
  end
  
  private

    def product_params
      params.require(:product).permit(:name)
    end

    def not_found
      render json: { error: 'Product not found' }, status: :not_found
    end
  
    def check_category
      category = Category.find_by(name: params[:category])

      if category.nil?
        render json: { error: 'Category not found!' }
      end
    end
end
