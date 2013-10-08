class DropDocumentsFiles < ActiveRecord::Migration
  def change
    drop_table :registered_users
  end
end
