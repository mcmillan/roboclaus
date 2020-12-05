class CreateBlockedPhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :blocked_phone_numbers do |t|
      t.string :phone_number

      t.timestamps
    end
  end
end
