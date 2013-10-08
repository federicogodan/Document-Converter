class ReferenceToUserRegistered < ActiveRecord::Migration
  def change
    add_column :registered_users, :user_id, :integer
    remove_column :registered_users, :email
  end
end
