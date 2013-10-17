class AddRefFormatToDocument < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.references :format
    end
  end
end
