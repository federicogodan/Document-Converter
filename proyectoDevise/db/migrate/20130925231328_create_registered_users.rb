class CreateRegisteredUsers < ActiveRecord::Migration
  def change
    create_table :registered_users do |t|
      t.string :email
      t.string :api_key
      t.string :secret_key
      t.integer :total_storage_assigned
      t.integer :documents_time_for_expiration

      t.timestamps
    end
  end
end
