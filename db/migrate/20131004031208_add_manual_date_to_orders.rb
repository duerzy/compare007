class AddManualDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :manualDate, :string
  end
end
