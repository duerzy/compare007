class AddIsErrorToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :isError, :string
  end
end
