class CreateSegments < ActiveRecord::Migration[7.0]
  def change
    create_table :segments do |t|
      t.string :name
      t.json :attributes_ranges

      t.timestamps
    end
  end
end
