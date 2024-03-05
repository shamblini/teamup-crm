require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:campaign) do
    Campaign.create(
      name: 'Test Campaign',
      goal_amount: 1000,
      start_date: '2021-04-01',
      end_date: '2021-04-30'
    )
  end

  context 'Sunny Day' do
    it 'creates a campaign in the database when created with correct attributes' do
      expect(campaign).to be_persisted
    end

    it 'edits a campaign in the database when edited with correct attributes' do
      campaign.update(goal_amount: 2000)

      expect(campaign.reload.goal_amount).to eq(2000)
    end

    context 'Rainy Day' do
      it 'does not create a campaign in the database when created with wrong attributes' do
        campaignBad = Campaign.create(
          name: nil,
          goal_amount: 1000,
          start_date: '2021-04-01',
          end_date: '2021-04-30'
        )

        expect(campaignBad).not_to be_persisted
      end

      it 'does not edit a campaign in the database when edited with wrong attributes' do
        campaign.update(goal_amount: -2000)

        expect(campaign.reload.goal_amount).not_to eq(-2000)
      end
    end
  end
end
