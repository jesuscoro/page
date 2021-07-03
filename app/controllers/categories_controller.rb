class CategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  before_action :check_category_products, only: %i[destroy]

  def index
    categories = Category.all
    render json: categories
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors }, status: :unprocessable_entity
    end 
  end

  def show
    category = Category.find(params[:id])
    render json: category
  end

  def update
    category = Category.find(params[:id])

    if category.update(category_params)
      render json: category, status: :ok
    else
      render json: { errors: category.errors }, status: :unprocessable_entity
    end
  end 

  def destroy
    category = Category.find(params[:id])
    category.destroy
    render json: 'Category deleted', status: :ok
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end

    def not_found
      render json: { error: 'Category not found' }, status: :not_found
    end

    def check_category_products
      category = Category.find(params[:id])
      products = category.products

      if products.count > 0
        render json: { error: 'Cannot delete category because it has products!' }
      end
    end
end 
