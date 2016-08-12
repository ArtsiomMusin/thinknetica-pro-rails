class AddForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :question_id, :integer
    add_column :questions, :answer_id, :integer
  end
end
