class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @currencies = []
  end
end
