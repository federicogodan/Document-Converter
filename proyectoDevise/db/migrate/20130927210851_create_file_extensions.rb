class CreateFileExtensions < ActiveRecord::Migration
  def change
    create_table :file_extensions do |t|
      t.integer :extension
      t.integer :can_be_converted_to

      t.timestamps
    end
  end
end
