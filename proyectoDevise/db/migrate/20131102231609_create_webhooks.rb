class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :url
      t.boolean :deleted
      t.integer :user_id

      t.timestamps
    end
  end
end
