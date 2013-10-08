class RemoveLastAccessFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :last_access
  end

  def down
    add_column :users, :last_access, :date
  end
end
