class RelationConvertedDocumentAndDocument < ActiveRecord::Migration
  def change
    change_table :converted_documents do |t|
      t.references :document
    end
  end
end
