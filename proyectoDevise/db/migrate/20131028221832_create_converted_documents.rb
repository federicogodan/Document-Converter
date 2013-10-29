class CreateConvertedDocuments < ActiveRecord::Migration
  def change
    create_table :converted_documents do |t|
      t.integer  :document_id
      t.integer  :format_id
      t.string   :download_link
      t.integer  :status
      t.integer  :size

      t.timestamps
    end
  end
end
