class AddManualRefundToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :isManualRefund, :string
  end
end
