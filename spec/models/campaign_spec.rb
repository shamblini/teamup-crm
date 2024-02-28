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

    it 'opens the campaign page when campaign name is clicked' do
      visit campaigns_path
      click_link campaign.name

      expect(page).to have_current_path(campaign_path(campaign))
    end

    it 'sorts campaigns by columns in ascending order when column header is clicked once' do
      # Implement the test logic for sorting by columns in ascending order
    end

    it 'sorts campaigns by columns in descending order when column header is clicked twice' do
      # Implement the test logic for sorting by columns in descending order
    end

    it 'opens the edit page of a campaign when edit link is clicked' do
      # Implement the test logic for opening the edit page of a campaign
    end

    it 'opens the campaign page when campaign name is clicked' do
      # Implement the test logic for opening the campaign page when campaign name is clicked
    end

    it 'opens the new campaign creation page when new campaign is clicked' do
      # Implement the test logic for opening the new campaign creation page
    end
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
