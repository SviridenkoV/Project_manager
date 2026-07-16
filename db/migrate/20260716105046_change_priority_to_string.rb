class ChangePriorityToString < ActiveRecord::Migration[8.1]
  def up
    change_column :tasks, :priority, :string, default: "medium"
  end

  def down
    change_column :tasks, :priority, :integer, default: 2
  end
end