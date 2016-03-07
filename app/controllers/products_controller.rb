class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :show, :destroy, :update]
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_admin

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
      redirect_to products_path
    else
      render products_new_path
    end
  end

  def update
    @product.update_attributes product_params
    if @product.save
      redirect_to products_path
    else
      render edit_product_path
    end
  end

  private

    def set_product
      if !@product = Product.find_by(id: params[:id])
        redirect_to products_path
      end
    end

    def product_params
      params.require(:product).permit(:name, :price, :sff_price)
    end
end
