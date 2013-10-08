class RemoveLastAccesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :last_acces
    remove_column :users, :registration_date
  end

  def down
    add_column :users, :registration_date, :date
    add_column :users, :last_acces, :date
  end
end
