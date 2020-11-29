class AddRecipientToGroupUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :group_users, :recipient, null: true, foreign_key: { to_table: :users }
  end
end
