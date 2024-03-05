# spec/features/campaign_spec.rb

require 'rails_helper'

RSpec.feature 'Campaign', type: :feature do
  let!(:campaign) do
    Campaign.create(
      name: 'Test Campaign',
      goal_amount: 1000,
      start_date: '2021-04-01',
      end_date: '2021-04-30'
    )
  end

  scenario 'opens the campaign page when campaign name is clicked' do
    visit campaigns_path
    click_link campaign.name

    expect(page).to have_current_path(campaign_path(campaign))
  end
end
