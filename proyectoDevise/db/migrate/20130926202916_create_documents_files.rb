class CreateDocumentsFiles < ActiveRecord::Migration
  def change
    create_table :documents_files do |t|
      t.string :email
      t.integer :document_number
      t.string :current_extension
      t.string :status
      t.date :conversion_end_date
      t.integer :size_in_bytes
      t.string :download_link

      t.timestamps
    end
  end
end
