class CreateUsersCounters < ActiveRecord::Migration
  def change
    create_table :users_counters do |t|
      t.references :user
      t.integer :counter

      t.timestamps
    end
    add_index :users_counters, :user_id
  end
end
