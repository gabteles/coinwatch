class OrdersController < ApplicationController
  def index
    @orders = Order.order(created_at: :desc).page(page_number)
  end

  def new
    @order = Order.new
  end

  private

  def page_number
    params[:page] || 1
  end
end
