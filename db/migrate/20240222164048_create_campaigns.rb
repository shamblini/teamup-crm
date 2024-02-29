class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.decimal :goal_amount
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
