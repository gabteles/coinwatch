class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @orders = OrdersService.fetch_for_user(current_user, page_number)
  end
  
  def new
    @currencies = CurrenciesService.get_all
    @order = Order.new
  end

  def create
    redirect_to(orders_path) if OrdersService.create(current_user, order_params)
  end

  private

  def page_number
    params[:page] || 1
  end

  def order_params
    params.require(:order).permit(
      :currency,
      :amount,
      :purchase_price
    )
  end
end
