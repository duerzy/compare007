class ManualsController < ApplicationController
	def index
	end

	def create
		@orders = Order.where("orderId = ?",params[:cost][:orderId])
	end

	def update
		@order = Order.find(params[:id])
		manualDate = params[:cost][:manualDate]
		if manualDate.nil? or manualDate.length < 6
			manualDate = @order.settleDate
		end
		@order.manualDate = manualDate
		@order.isManualRefund = Time.new
		@order.save
		redirect_to daily_settles_path
	end

	def show
		@orders = []
		order = Order.find(params[:id])
		@orders << order
		render 'create'
	end
	
	def destroy
		@order = Order.find(params[:id])
		@order.isManualRefund = nil
		@order.manualDate = nil
		@order.save
		redirect_to daily_settles_path
	end
end
