class ErrorOrdersController < ApplicationController
	def index
		@orders = Order.where("isError is not null")
	end

	def new 
	end

	def create
		@orders = Order.where("orderId = ?",params[:errorOrder][:orderId])
	end

	def update
		@order = Order.find(params[:id])
		@order.isError = Time.now
		@order.save
		redirect_to error_orders_path
	end

end
