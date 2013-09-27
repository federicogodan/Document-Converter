class ActualizationDocument < ActiveRecord::Migration
  def change
    change_column :documents, :original_extension, :integer
  end
end
