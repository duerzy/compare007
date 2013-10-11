class CreateBill007s < ActiveRecord::Migration
  def change
    create_table :bill007s do |t|
      t.string :recordTime
      t.integer :refundAmount
      t.integer :extraAmount
      t.integer :billAmount
      t.integer :balance
      t.string :TraceNumber007

      t.timestamps
    end
  end
end
