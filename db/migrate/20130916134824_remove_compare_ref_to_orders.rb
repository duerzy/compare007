class RemoveCompareRefToOrders < ActiveRecord::Migration
  def change
    remove_reference :orders, :compare, index: true
  end
end
