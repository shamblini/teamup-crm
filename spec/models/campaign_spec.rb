require 'rails_helper'

# sunny day
RSpec.describe Campaign, type: :model do
  context 'when creating a new campaign' do
    it 'creates a campaign in the database' do
      campaign = Campaign.create(
        name: 'Test Campaign',
        goal_amount: 1000,
        start_date: '2021-04-01',
        end_date: '2021-04-30'
      )

      # Check if the campaign object is persisted in the database
      expect(campaign).to be_persisted

      expect(campaign.name).to eq('Test Campaign')
      expect(campaign.goal_amount).to eq(1000)
      expect(campaign.start_date).to eq('2021-04-01')
      expect(campaign.end_date).to eq('2021-04-30')
    end
  end
end

# rainny day
RSpec.describe Campaign, type: :model do 
  describe "validations" do
    it "does not persist a campaign without all the required attributes" do
      campaign = Campaign.new
      expect(campaign.save).to be_falsey
    end
  end
end
