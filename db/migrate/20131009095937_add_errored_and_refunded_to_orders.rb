class AddErroredAndRefundedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :errored, :string
    add_column :orders, :refunded, :string
  end
end
