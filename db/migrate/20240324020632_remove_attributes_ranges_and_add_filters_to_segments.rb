class RemoveAttributesRangesAndAddFiltersToSegments < ActiveRecord::Migration[6.0]
  def change
    remove_column :segments, :attributes_ranges
    add_column :segments, :filters, :string
  end
end
