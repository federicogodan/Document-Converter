class CreateWhsents < ActiveRecord::Migration
  def change
    create_table :whsents do |t|
      t.string :url
      t.string :urldoc
      t.integer :state
      t.integer :attempts
      t.integer :webhoook_id
      t.integer :notification 

      t.timestamps
    end
  end
end
