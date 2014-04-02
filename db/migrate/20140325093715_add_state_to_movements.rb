class AddStateToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :privacy, :string
  end
end
