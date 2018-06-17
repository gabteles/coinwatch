class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @portfolio = DashboardsService.portfolio_for(current_user)
  end
end
