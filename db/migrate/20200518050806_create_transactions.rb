class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.references :wallet, null: false, foreign_key: { to_table: 'wallets' }
      t.references :sender, null: false, foreign_key: { to_table: 'users' }
      t.references :receiver, null: false, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
