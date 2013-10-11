class RemoveCompareRefToRecord007 < ActiveRecord::Migration
  def change
    remove_reference :record007s, :compare, index: true
  end
end
