class DropTableFileExtension < ActiveRecord::Migration
  def change
    drop_table :file_extensions
  end
end
