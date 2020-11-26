class AddStateToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :state, :string
  end
end
