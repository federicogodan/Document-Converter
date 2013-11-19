class CreateWhsents < ActiveRecord::Migration
  def change
    create_table :whsents do |t|
      t.string :url
      t.integer :state
      t.integer :attempts
      t.integer :webhoook_id

      t.timestamps
    end
  end
end
