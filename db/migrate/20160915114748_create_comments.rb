class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :body

      t.timestamps
    end
    add_column :comments, :commentable_id, :string
    add_column :comments, :commentable_type, :string
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
