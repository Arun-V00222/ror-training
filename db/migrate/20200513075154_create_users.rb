class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password
      t.string :user_email

      t.timestamps
    end
    add_index :users, :user_email, unique: true
  end
end
