class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :email
      t.string :url
      t.boolean :deleted

      t.timestamps
    end
  end
end
