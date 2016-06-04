class UserManagementsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_admin
  before_action :redirect_to_root_if_not_superadmin_for_superadmin_in_user_params, only: [:create, :update]

  def initialize
    @options = {}
    super
  end

  def index
    @users = User.order(:last_name)
  end

  def new
    @options[:edit] = false
    @user = User.new
  end

  def create
    @user = User.new(user_managements_params)
    create_order(@user) if params[:payment]
    if @user.save and !@user.errors.any?
      flash[:success] = "Użytkownik dodany"
      redirect_to user_managements_path
    else
      render 'new'
    end
  end

  def edit
    @options[:edit] = true
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    create_order(@user) if params[:payment]
    @user.save
    @user.update_attributes(user_managements_params)
    if !@user.errors.any?
      flash[:success] = "Dane zaktualizowane"
      redirect_to user_managements_path
    else
      render 'edit'
    end
  end

  private
    def user_managements_params
      params.require(:user).permit(:first_name,:last_name,:activated,:admin,:sff_validated, :password, :password_confirmation, :email, :superadmin)
    end

    def create_order(user)
      order = user.orders.build
      order.payed = true
      order.payment_confirmed = true
      order_item = order.order_items.build
      order_item.product = Product.find_by(name: "main")
    end
end
