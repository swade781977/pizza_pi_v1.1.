class MenusController < ApplicationController
    before_action :current_cart
    before_action :check_for_cart
    before_action :current_order
  
    def index
      @menu_items = MenuItem.all
      @line_items = current_order.line_items.new
      
    end
  
    def show
      @menu_item = MenuItem.find(params[:id])
      @line_items = current_order.line_items.new
    end
  
  
  
    
  end