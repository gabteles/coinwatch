class OrdersController < ApplicationController
  def index
    @orders = Order.order(created_at: :desc).page(page_number)
  end
  
  def new
    @currencies = CurrenciesService.get_all
    @order = Order.new
  end

  def create
    #OrdersService.create()
    @order = Order.new(order_params)
    @order.id = SecureRandom.uuid
    success = @order.save

    redirect_to(orders_path) if success
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
