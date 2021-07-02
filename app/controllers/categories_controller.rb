class CategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

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

  def upadte 
  end 

  def destroy
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end

    def not_found
      render json: { error: 'Category not found' }, status: :not_found
    end
end 
