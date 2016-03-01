class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :show, :destroy, :update]

  def index
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def show
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render products_new_path
    end
  end

  def update
    @product.update_attributes product_params
    if @product.save
      redirect_to @product
    else
      render 'edit'
    end
  end

  private

    def set_product
      if !@product = Product.find_by(id: params[:id])
        redirect_to products_path
      end
    end

    def product_params
      params.require(:product).permit(:name, :price, :authorized)
    end
end
