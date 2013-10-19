class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :document_number, uniqueness: true
      t.date :creation_date
      t.string :name
      t.boolean :uploading


      #associations
      t.belongs_to :user
      t.belongs_to :format
      
      t.timestamps
    end

    add_index :documents, [:user_id,:document_number]
  end
end
