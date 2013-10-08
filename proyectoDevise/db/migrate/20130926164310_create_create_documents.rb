class CreateCreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :email, uniqueness: true
      t.integer :document_number, uniqueness: true
      t.date :creation_date
      t.string :name
      t.boolean :uploading
      t.string :original_extension

      t.timestamps
    end
    add_index :documents, :email
    add_index :documents, [:email,:document_number]
  end
end
