class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :avatar
      t.boolean :is_admin, default: false

      t.timestamps null: false
    end
  end
end
