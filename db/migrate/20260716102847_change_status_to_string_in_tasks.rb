class ChangeStatusToStringInTasks < ActiveRecord::Migration[8.1]
  def change
    change_column :tasks, :status, :string, default: "to_do"
  end
end