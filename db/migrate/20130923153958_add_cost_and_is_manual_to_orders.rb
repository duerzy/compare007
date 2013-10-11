class AddCostAndIsManualToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cost, :integer
    add_column :orders, :isManual, :string
  end
end
