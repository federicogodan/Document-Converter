class AddSurnameBirthDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :surname, :string
    add_column :users, :birth_date, :date
  end
end
