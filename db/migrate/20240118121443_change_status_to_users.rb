class ChangeStatusToUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :status, :string, default: "unblock"
  end
  def down
    change_column :users, :status, :string, default: "block"
  end
end
