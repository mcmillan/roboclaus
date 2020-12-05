class AddStateToInvitations < ActiveRecord::Migration[6.0]
  def change
    add_column :invitations, :state, :string
  end
end
