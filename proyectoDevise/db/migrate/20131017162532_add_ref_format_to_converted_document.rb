class AddRefFormatToConvertedDocument < ActiveRecord::Migration
  def change
    change_table :converted_documents do |t|
      t.references :format
    end
  end
end
