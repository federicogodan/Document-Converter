class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string :name
      
      #self associations
      #t.integer :origin
      #t.integer :destinies

      t.timestamps
    end
    
    create_table :format_destinies do |t|
      t.integer :format_id
      t.integer :destiniy_id
    end
  end
end
