class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.belongs_to :user
      t.belongs_to :format
      t.string :file
      t.string :name
      t.integer :size
      t.boolean :expired

      t.timestamps
    end
  end
end
