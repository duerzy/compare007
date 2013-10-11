class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :orderId
      t.string :busCode
      t.string :busName
      t.string :tradeTime
      t.string :settleDate
      t.integer :amount
      t.string :payStatus
      t.string :payMethod
      t.string :settleNumber
      t.string :mno
      t.string :bill007Id
      t.references :compare, index: true

      t.timestamps
    end
  end
end
