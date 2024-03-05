# spec/features/donation_spec.rb

require 'rails_helper'

RSpec.feature 'Donation', type: :feature do
  let!(:donation) do
    Donation.create(
      donor_name: 'Test Donor',
      amount: 1000,
      donation_date: '2021-04-01',
      campaign_id: 1
    )
  end

  scenario 'opens the donation page when donation name is clicked' do
    visit donations_path
    click_link donation.donor_name

    expect(page).to have_current_path(donation_path(donation))
  end

  scenario 'displays an error notice when searching for a donation that does not exist' do
    visit donations_path
    fill_in 'search', with: 'Test Donor'
    click_button 'Search'

    expect(page).to have_content('No donation found with the donor name')
  end
end
