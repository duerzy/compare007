class AddPhoneNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :phoneNumber, :string
  end
end
