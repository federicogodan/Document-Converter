class Version1 < ActiveRecord::Migration
  def change
    add_column :users, :registration_date, :date
    add_column :users, :last_acces, :date
    add_column :users, :profile_type, :string
  end
end