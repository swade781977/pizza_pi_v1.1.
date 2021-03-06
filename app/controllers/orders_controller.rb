class OrdersController < ApplicationController
    before_action :set_order, only: [:edit, :update, :destroy]
    before_action :current_cart
    before_action :check_for_cart

    def index
        @orders = Order.all

    end

    def show
        @orders = Order.orders_by_cart(current_cart.id).good_orders
    end

    def new
        @menu_items = MenuItem.all
        current_order.fake = true
        current_order.save
        binding.pry
        @order = Order.new
        @order.line_items.build(quantity: "0")
        @order.line_items.build(quantity: "0")
        @order.line_items.build(quantity: "0")
        @order.line_items.build(quantity: "0")
    end

    def create
        
        @order = Order.create(order_params)
        if @order.valid?
            @order.line_items.each do |b|
                b.order_id = @order.id
                b.unit_price = b.menu_item.price
                b.line_item_subtotal = b.menu_item.price * b.quantity
                b.save
                if b.quantity == 0
                    b.delete
                end  
            end
            redirect_to cart_path(@current_cart), notice: "Items added to cart."
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        @order.update(order_params)
        @order.save
    end

    def destroy
        @order.destroy
        redirect_to cart_path
    end

   

    private

    def order_params
        params.require(:order).permit(:tax, :delivery, :delivery_fee, :order_subtotal, :total, :datetime, :order_number, :line_item_id, :cart_id, :order_status, :tax_rate, :for_user,
            line_items_attributes: [
                :line_item_subtotal,
                :quantity,
                :order_id,
                :menu_item_id,
                :unit_price,
            ]
        )
    end

    def set_order
        @order = Order.find_by(id: params[:id])
    end
end
