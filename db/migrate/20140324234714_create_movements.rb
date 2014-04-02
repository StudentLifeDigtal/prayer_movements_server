class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :name
      t.date :founded
      t.string :founder
      t.text :short_description
      t.text :long_description
      t.text :mission
      t.string :phone
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
