class AddAtributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string
    add_column :users, :secret_key, :string
    add_column :users, :total_storage_assigned, :integer
    add_column :users, :documents_time_for_expiration, :integer
  end
end
