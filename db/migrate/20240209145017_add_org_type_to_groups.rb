class AddOrgTypeToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :org_type, :string
  end
end
