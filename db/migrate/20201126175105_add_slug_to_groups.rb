class AddSlugToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :slug, :string
    add_index :groups, :slug, unique: true
  end
end
