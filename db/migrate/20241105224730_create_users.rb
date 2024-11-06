class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :role, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end