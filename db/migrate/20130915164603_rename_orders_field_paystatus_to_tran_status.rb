class RenameOrdersFieldPaystatusToTranStatus < ActiveRecord::Migration
  def change
	  rename_column :orders, :payStatus, :tranStatus
  end
end
