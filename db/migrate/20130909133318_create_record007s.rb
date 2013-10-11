class CreateRecord007s < ActiveRecord::Migration
  def change
    create_table :record007s do |t|
      t.string :recordTime
      t.string :traceNumber007
      t.string :bill007Id
      t.string :namedAmount
      t.string :trueAmount
      t.string :phoneNumber
      t.string :status
      t.string :comment
      t.integer :settleAmount
      t.integer :commission
      t.references :compare, index: true

      t.timestamps
    end
  end
end
