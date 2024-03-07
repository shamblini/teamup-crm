class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :type
      t.references :donations, null: false, foreign_key: true
      t.integer :permission_set

      t.timestamps
    end
  end
end
