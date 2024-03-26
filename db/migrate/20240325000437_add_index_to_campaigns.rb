class AddIndexToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_reference :campaigns, :group, foreign_key: true
  end
end