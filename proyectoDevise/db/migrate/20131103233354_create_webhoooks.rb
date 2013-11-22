class CreateWebhoooks < ActiveRecord::Migration
  def change
    create_table :webhoooks do |t|
      t.string :url
      t.boolean :enabled
      t.integer :user_id

      t.timestamps
    end
  end
end
