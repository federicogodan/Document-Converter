class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.integer :format_id
      t.string :file
      t.string :name
      t.integer :size
      t.boolean :expired

      t.timestamps
    end
  end
end
