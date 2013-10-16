class AddOriginAndDestinyToFormat < ActiveRecord::Migration
  def change
    add_column :formats, :origin, :integer
    add_column :formats, :destiny, :integer
  end
end
