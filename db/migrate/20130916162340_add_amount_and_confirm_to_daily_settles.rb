class AddAmountAndConfirmToDailySettles < ActiveRecord::Migration
  def change
    add_column :daily_settles, :amount, :integer
    add_column :daily_settles, :confirm, :string
  end
end
