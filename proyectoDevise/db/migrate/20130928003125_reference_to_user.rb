class ReferenceToUser < ActiveRecord::Migration
  def change 
    add_column :documents, :id_user, :integer
    remove_column :documents, :email
  end
end
