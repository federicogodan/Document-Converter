class AddingIndex < ActiveRecord::Migration
  def change
    add_index :documents_files, [:email,:document_number,:current_extension], name: "index_on_documents_file_email_number_extension"
  end
end
