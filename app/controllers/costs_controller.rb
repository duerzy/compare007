class CostsController < ApplicationController
	def index
	end

	def create
		@orders = Order.where("orderId = ?",params[:cost][:orderId])
	end

	def update
		@order = Order.find(params[:id])
		if params[:cost][:cost] and  not @order.cost == params[:cost][:cost]
			@order.cost =( Float params[:cost][:cost]) * 100
			manualDate = params[:cost][:manualDate]
			if manualDate.nil? or manualDate.length < 6
				manualDate = @order.settleDate
			end
			@order.manualDate = manualDate
			@order.isManual = Time.new
			@order.save
			redirect_to daily_settles_path
		else
			@orders = Order.where("orderId = ?",@order.orderId)
			render 'create'
		end
	end

	def show
		@orders = []
		order = Order.find(params[:id])
		@orders << order
		render 'create'
	end

	def destroy
		@order = Order.find(params[:id])
		@order.isManual = nil
		@order.cost = nil
		@order.manualDate = nil
		@order.save
		redirect_to daily_settles_path
	end

end
