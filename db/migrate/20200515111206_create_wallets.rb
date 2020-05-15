class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.float :amount, null: false
      t.boolean :is_active, null: false
      t.boolean :is_primary, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
