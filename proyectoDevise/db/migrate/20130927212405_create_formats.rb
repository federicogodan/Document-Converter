class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string :name
      
      #self associations
      t.integer :origin
      t.integer :destinies

      t.timestamps
    end
  end
end
