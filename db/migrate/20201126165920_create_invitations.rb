class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.belongs_to :group, null: false, foreign_key: true
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
