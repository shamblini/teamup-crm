class CreateFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :filters do |t|
      t.references :segment, null: false, foreign_key: true
      t.string :attribute_type
      t.text :data

      t.timestamps
    end
  end
end
