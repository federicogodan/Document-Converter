class RenameDocumentsFile < ActiveRecord::Migration
  def change
    rename_table :documents_files, :converted_document    
  end
end
