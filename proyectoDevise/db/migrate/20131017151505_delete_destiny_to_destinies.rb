class DeleteDestinyToDestinies < ActiveRecord::Migration
  def change
    remove_column :formats, :destiny
    add_column :formats, :destinies, :integer
  end
end
