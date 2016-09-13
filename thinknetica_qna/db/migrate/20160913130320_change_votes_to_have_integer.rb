class ChangeVotesToHaveInteger < ActiveRecord::Migration[5.0]
  def change
    remove_column :votes, :positive
    add_column :votes, :state, :integer, default: 0
  end
end
