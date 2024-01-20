class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :type
      t.string :password_digest
      t.string :email
      t.string :phone
      t.string :status, default: "block"

      t.timestamps
    end
  end
end
