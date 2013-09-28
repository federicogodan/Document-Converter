class ReferenceToUserDocFile < ActiveRecord::Migration
  def change
    add_column :documents_files, :user_id, :integer
    remove_column :documents_files, :email
    
    rename_column :documents, :id_user, :user_id
  end
end
