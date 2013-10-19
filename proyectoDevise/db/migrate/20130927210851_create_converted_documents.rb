class CreateConvertedDocuments < ActiveRecord::Migration
  def change
    create_table :converted_documents do |t|
      t.string :name
      t.date :conversion_end_date
      t.integer :document_number
      t.string :download_link
      t.integer :size_in_bytes
      t.string :status
      
      #associations
      t.belongs_to :document
      t.belongs_to :format
      # t.belongs_to :user ##it's generated :through :documents in :user
        

      t.timestamps
    end

        add_index :converted_documents, [:document_number,:format_id], name: "index_on_converted_documents_number_format"
  end
end
