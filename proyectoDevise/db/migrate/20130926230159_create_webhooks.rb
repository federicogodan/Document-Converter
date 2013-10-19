class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :url
      t.boolean :deleted

      #Associations
      t.belongs_to :user

      t.timestamps
    end
  end
end
