class AddFileToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :file, :string
  end
end
