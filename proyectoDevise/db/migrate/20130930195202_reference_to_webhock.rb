class ReferenceToWebhock < ActiveRecord::Migration
  def change
    add_column :webhooks, :user_id, :integer
    remove_column :webhooks, :email
  end
end
