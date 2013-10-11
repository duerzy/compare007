class CompareWorksController < ApplicationController 
  def index

  end

  def show_dispached
	  @compare = Compare.find params[:id]
	  @okOrder = Order.where("orders.compare_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@compare.id,74,1572,'paid').where("orders.bill007Id IN (select bill007Id from record007s where compare_id = ?) ",@compare.id)
	  @errorOrder = Order.where("orders.compare_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ? ",@compare.id,74,1572,'paid').where("orders.bill007Id NOT IN (select bill007Id from record007s where compare_id = ?) ",@compare.id)

	  record007s = Record007.where("record007s.compare_id = ?", @compare.id).where("record007s.bill007Id NOT IN (select bill007Id from orders where orders.compare_id = ? AND (busCode = ? OR busCode = ?) AND tranStatus = ?)",@compare.id,74,1572,'paid')


	  @recordHash = Hash.new
	  record007s.each do |r007|
		  @recordHash[r007.bill007Id] = r007
	  end


	  @totalAmount = 0.0;

	  @okOrder.each do |order|
		  @totalAmount += order.amount
	  end
	  @totalAmount /= 100

  end

  def create
	  require 'fileutils'
	  
	  
	  Order.transaction do
		  require 'spreadsheet'
		  Spreadsheet.client_encoding = 'UTF-8'
		  book = Spreadsheet.open params[:compare][:orderFile].path
		  sheet1 = book.worksheet '有卡'

		  sheet1.each 1 do |row|
			  if row[0] == nil 
				  break
			  end

			  begin
				  order = Order.new
				  order.orderId = row[0].to_s.gsub(/\.0$/,"")
				  order.busCode = row[3].to_s.gsub(/\.0$/,"")
				  order.busName = row[4]
				  order.tradeTime = row[6].to_s.gsub(/\.0$/,"")
				  order.settleDate = row[7].to_s.gsub(/\.0$/,"")
				  order.amount = row[9].to_f*100
				  order.tranStatus = row[12]
				  order.payMethod = row[14]
				  order.settleNumber=row[15].to_s.gsub(/\.0$/,"")
				  order.phoneNumber = row[16].to_s.gsub(/\.0$/,"")
				  order.mno = row[17]
				  order.bill007Id = row[23].to_s.gsub(/\.0$/,"")
				  order.save!
			  rescue ActiveRecord::RecordNotUnique => e
				  Rails.logger.warn(e)
			  end



		  end


		  sheet2 = book.worksheet '无卡'

		  sheet2.each 1 do |row|
			  if row[0] == nil 
				  break
			  end

			  begin
				  order = Order.new
				  order.orderId = row[0].to_s.gsub(/\.0$/,"")
				  order.busCode = row[3].to_s.gsub(/\.0$/,"")
				  order.busName = row[4]
				  order.tradeTime = row[6].to_s.gsub(/\.0$/,"")
				  order.settleDate = row[7].to_s.gsub(/\.0$/,"")
				  order.amount = row[9].to_f*100
				  order.tranStatus = row[12]
				  order.payMethod = row[14]
				  order.settleNumber=row[15].to_s.gsub(/\.0$/,"")
				  order.phoneNumber = row[16].to_s.gsub(/\.0$/,"")
				  order.mno = row[17]
				  order.bill007Id = row[23].to_s.gsub(/\.0$/,"")
				  order.save!
			  rescue ActiveRecord::RecordNotUnique => e
				  Rails.logger.warn(e)
			  end



		  end
		  
		  File.open params[:compare][:record007File].path do |file|
			  file.gets
			  while line = file.gets
				  cols = line.split ','
				  cols.each do |col|
					  col.delete!("\"")
				  end

				  begin
					  record = Record007.new
					  record.recordTime = cols[0].delete!(" ").delete!("-").delete!(":").gsub(/\.0$/,"");
					  record.traceNumber007 = cols[3]
					  record.bill007Id = cols[4]
					  record.namedAmount = cols[5]
					  record.trueAmount = cols[6]
					  record.phoneNumber = cols[7]
					  record.status = cols[8]
					  record.comment = cols[9]
					  record.settleAmount = cols[10].to_f*100
					  record.commission = cols[11].to_f*100
					  record.save!
				  rescue ActiveRecord::RecordNotUnique => e
					  Rails.logger.warn(e)
				  end
			  end
		  end


		  File.open params[:compare][:bill007File].path do |file|
			  file.gets
			  while line = file.gets
				  cols = line.split ','
				  cols.each do |col|
					  col.delete!("\"")
				  end
				  begin
					  record = Bill007.new
					  record.recordTime = cols[2].delete!(" ").delete!("-").delete!(":").gsub(/\.0$/,"");
					  record.refundAmount = cols[3].to_f*100
					  record.extraAmount = cols[4].to_f*100
					  record.billAmount = cols[5].to_f*100
					  record.balance = cols[6].to_f*100
					  record.TraceNumber007 = cols[7].gsub(/\D/,'')
					  record.save!
				  rescue ActiveRecord::RecordNotUnique => e
					  Rails.logger.warn(e)
				  end
			  end
		  end

	  end
	  redirect_to welcome_index_path

  end

  def new
  end

end
