class AddIndexFileExtension < ActiveRecord::Migration
  def change
    add_index :file_extensions, [:can_be_converted_to, :extension] 
  end

end
