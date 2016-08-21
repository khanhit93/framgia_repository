class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :telephone
      t.string :password_digest
      t.boolean :sex
      t.boolean :is_admin, default: false
      t.boolean :activation
      t.datetime :active_at
      t.timestamps null: false
    end
  end
end
