class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :movement_id
      t.string :status

      t.timestamps
    end
  end
end
