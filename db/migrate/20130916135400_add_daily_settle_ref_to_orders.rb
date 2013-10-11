class AddDailySettleRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :dailySettle, index: true
  end
end
