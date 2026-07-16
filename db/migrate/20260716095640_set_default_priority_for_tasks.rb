class SetDefaultPriorityForTasks < ActiveRecord::Migration[8.1]
  def change
    change_column_default :tasks, :priority, 2
  end
end
