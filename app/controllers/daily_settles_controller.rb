class DailySettlesController < ApplicationController
	def round(x)
		x.round
	end

	def index
		@dailySettles = DailySettle.all;
	end

	def show
		@dailySettle = DailySettle.find(params[:id]);
		sd = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("payMethod = 'SD' and (busCode = '1572' or busCode = '74') ").sum("amount-round(amount*0.0038)");
		nc = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("payMethod = 'NC' and (busCode = '1572' or busCode = '74')").sum("amount-round(amount*0.006)");
		upmp = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("payMethod = 'UNKOWN' or payMethod = 'UPMP' and (busCode = '1572' or busCode = '74')").sum("amount-round(amount*0.006)");
		other = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("not (payMethod = 'SD' or payMethod = 'NC' or payMethod = 'UNKOWN' or payMethod = 'UPMP') and (busCode = '1572' or busCode = '74')").sum("amount-round(amount*0.006)");
		@sd_r = sd#-round(sd*0.0038);
		@nc_r = nc#-round(nc*0.006);
		@upmp_r = upmp#-round(upmp*0.006);
		@other_r = other#-round(other*0.006);
		@total = @sd_r+@nc_r+@upmp_r+@other_r
		if not @dailySettle.confirm.nil?
			mayerrorOrders = (Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('LEFT OUTER JOIN  v_bill007_records ON v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billTime IS NULL").order("orderId")).readonly(false)
			@errorOrders = []
			mayerrorOrders.each do |order|
				if order.errored.nil?
					order.errored = Time.now
					order.save
				end
				if order.isManual.nil? and order.isManualRefund.nil?
					refundOrder = Order.where("orderId =? and tranStatus = 'refund' ",order.orderId).count("*")
					if refundOrder == 0
						@errorOrders << order  
					end
				end
			end

			@needRefunds = []
			startTime = (Time.gm(@dailySettle.date[0..3],@dailySettle.date[4..5],@dailySettle.date[6..7]) - 60*60).to_s.delete!(" ").delete!("-").delete!(":"    ).gsub(/UTC$/,"")
			startTime00 = (Time.gm(@dailySettle.date[0..3],@dailySettle.date[4..5],@dailySettle.date[6..7])).to_s.delete!(" ").delete!("-").delete!(":"    ).gsub(/UTC$/,"")
			endTime = (Time.gm(@dailySettle.date[0..3],@dailySettle.date[4..5],@dailySettle.date[6..7]) + 60*60*23 ).to_s.delete!(" ").delete!("-").delete!(":"    ).gsub(/UTC$/,"")
			#m007refund = Order.where("tranStatus = 'purchase' and bill007Id in (select bill007Id from v_bill007_records where refundAmount > 0)")
			m007refund = (Order.where(" (busCode = ? OR busCode = ?) AND tranStatus = ? ",74,1572,'purchase').joins('RIGHT OUTER JOIN v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.refundAmount > 0").where("v_bill007_records.billTime >= ? and v_bill007_records.billTime < ? ",startTime,endTime)).readonly(false)
			m007refund.each do |order|
				if order.refunded.nil?
					order.refunded = Time.now
					order.save
				end
				if order.isManual.nil? and order.isManualRefund.nil?
					refundOrder = Order.where("orderId =? and tranStatus = 'refund' ",order.orderId).count("*")
					if refundOrder == 0
						@needRefunds << order
					end
				end
			end

			@manualOrders = Order.where(" (busCode = ? OR busCode = ?) AND tranStatus = ? ",74,1572,'purchase').where("isManual is not null and manualDate =?", @dailySettle.date);
			@manualRefundOrders = Order.where(" (busCode = ? OR busCode = ?) AND tranStatus = ? ",74,1572,'purchase').where("isManualRefund is not null and manualDate =?", @dailySettle.date);
			@total007Refund = VBill007Record.where("v_bill007_records.refundAmount > 0").where("v_bill007_records.billTime >= ? and v_bill007_records.billTime < ? ",startTime,endTime).sum("v_bill007_records.refundAmount")

			cmccOk007Order = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('Inner join v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billAmount > 0").where("mno = '移动'").sum("v_bill007_records.namedAmount")
			noncmccOk007Order = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('Inner join v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billAmount > 0").where("not mno = '移动'").sum("v_bill007_records.namedAmount")
			cmccOk007Order2324 = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('Inner join v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billAmount > 0").where("mno = '移动'").where("v_bill007_records.billTime < ? ",startTime00).sum("v_bill007_records.namedAmount")
			noncmccOk007Order2324 = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('Inner join v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billAmount > 0").where("not mno = '移动'").where("v_bill007_records.billTime < ? ",startTime00).sum("v_bill007_records.namedAmount")
			cmccOk007Order2423 = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('Inner join v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billAmount > 0").where("mno = '移动'").where("v_bill007_records.billTime >= ? ",startTime00).sum("v_bill007_records.namedAmount")
			noncmccOk007Order2423 = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'purchase').joins('Inner join v_bill007_records on v_bill007_records.bill007Id = orders.bill007Id').where("v_bill007_records.billAmount > 0").where("not mno = '移动'").where("v_bill007_records.billTime >= ? ",startTime00).sum("v_bill007_records.namedAmount")
			@manualCost = 0
			@manualOrders.each do |order|
				@manualCost += order.cost
			end
			@cmccCost = cmccOk007Order * 100 * 0.993
			@otherCost = noncmccOk007Order * 100 * 0.99
			@cmccCost2324 = cmccOk007Order2324 * 100 * 0.993
			@otherCost2324 = noncmccOk007Order2324 * 100 * 0.99
			@cmccCost2423 = cmccOk007Order2423 * 100 * 0.993
			@otherCost2423 = noncmccOk007Order2423 * 100 * 0.99
			@total007Cost = @cmccCost + @otherCost
			
			endTime24 = (Time.gm(@dailySettle.date[0..3],@dailySettle.date[4..5],@dailySettle.date[6..7]) + 60*60*24).to_s.delete!(" ").delete!("-").delete!(":"    ).gsub(/UTC$/,"")
			total007RefundTile24 = VBill007Record.where("v_bill007_records.refundAmount > 0").where("v_bill007_records.billTime >= ? and v_bill007_records.billTime < ? ",endTime,endTime24).sum("v_bill007_records.refundAmount")
			total007CostTile24 = VBill007Record.where("v_bill007_records.billAmount > 0").where("v_bill007_records.billTime >= ? and v_bill007_records.billTime < ? ",endTime,endTime24).sum("v_bill007_records.billAmount")
			@total007Cost24 = total007CostTile24 - total007RefundTile24 


			@manualRefundSum = 0;
			@seemsErrorRefund = [];
			@manualRefundOrders.each do |order|
				@manualRefundSum += order.amount

				refund007 = VBill007Record.where("bill007Id = ? and refundAmount > 0",order.bill007Id).count("*")
				if order.errored.nil? and order.refunded.nil?  and refund007 == 0
					@seemsErrorRefund << order
				end
			end

			@seems007cheat = VBill007Record.where("v_bill007_records.billAmount > 0").where("v_bill007_records.billTime > ? and v_bill007_records.billTime < ? ",startTime,endTime).joins("left outer join orders on v_bill007_records.bill007Id = orders.bill007Id").where("orders.id is null")

			refundOrders = Order.where("dailySettle_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@dailySettle.id,74,1572,'refund')
			refundOrders.each do |order|
				refund007 = VBill007Record.where("bill007Id = ? and refundAmount > 0",order.bill007Id).count("*")
				purchaseOrder = Order.where("orderId = ? AND tranStatus = ? ",order.orderId,'purchase').take
				if purchaseOrder.nil?
					@seemsErrorRefund << order
				elsif purchaseOrder.errored.nil? and purchaseOrder.refunded.nil?  and refund007 == 0
					@seemsErrorRefund << order
				end
			end

			
		end

	end

	def new
	end

	def update
		@dailySettle = DailySettle.find(params[:id]);
		sd = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("payMethod = 'SD' and (busCode = '1572' or busCode = '74') ").sum("amount-round(amount*0.0038)");
		nc = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("payMethod = 'NC' and (busCode = '1572' or busCode = '74')").sum("amount-round(amount*0.006)");
		upmp = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("payMethod = 'UNKOWN' or payMethod = 'UPMP' and (busCode = '1572' or busCode = '74')").sum("amount-round(amount*0.006)");
		other = Order.where("isError is null").where("settleDate = ?",@dailySettle.date).where("not (payMethod = 'SD' or payMethod = 'NC' or payMethod = 'UNKOWN' or payMethod = 'UPMP') and (busCode = '1572' or busCode = '74')").sum("amount-round(amount*0.006)");
		@sd_r = sd#-round(sd*0.0038);
		@nc_r = nc#-round(nc*0.006);
		@upmp_r = upmp#-round(upmp*0.006);
		@other_r = other#-round(other*0.006);
		@total = @sd_r+@nc_r+@upmp_r+@other_r
		if not @total == @dailySettle.amount
			@error_msg = "统计金额#{Float(@total)/100}和输入的结算金额#{Float(@dailySettle.amount)/100}不一致，请仔细核对"
			render 'show'
			return
		end
		orders = Order.where("isError is null").where("settleDate = ? and (busCode = '1572' or busCode = '74')",@dailySettle.date)
		Order.transaction do
			orders.each do |order|
				order.dailySettle = @dailySettle
				order.save
			end
			@dailySettle.confirm = Time.new
			@dailySettle.save
		end
		redirect_to daily_settles_path;
	end

	def create
		amount = Float(params[:dailySettle][:amount])*100
		@dailySettle = DailySettle.new 
		@dailySettle.amount = amount
		@dailySettle.date = params[:dailySettle][:date]
		if @dailySettle.save
			redirect_to @dailySettle
		else
			render 'new'
		end
	end

	def destroy
		@dailySettle = DailySettle.find(params[:id]);
		@dailySettle.destroy
		redirect_to daily_settles_path
	end
end

