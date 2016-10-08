class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :subscriptions, :user_id
  end
end
