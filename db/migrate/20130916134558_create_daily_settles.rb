class CreateDailySettles < ActiveRecord::Migration
  def change
    create_table :daily_settles do |t|
      t.string :date

      t.timestamps
    end
  end
end
