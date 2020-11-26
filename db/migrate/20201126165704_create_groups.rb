class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :budget
      t.date :deadline

      t.timestamps
    end
  end
end
