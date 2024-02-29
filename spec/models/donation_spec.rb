require 'rails_helper'

RSpec.describe Donation, type: :model do
  
  let(:donation) do
    Donation.create(
      donor_name: 'Test Donor',
      amount: 1000,
      donation_date: '2021-04-01',
      campaign_id: 1
    )
  end

  context 'Sunny Day' do
    it 'creates a donation in the database when created with correct attributes' do
      expect(donation).to be_persisted
    end

    it 'edits a donation in the database when edited with correct attributes' do
      donation.update(amount: 2000)

      expect(donation.reload.amount).to eq(2000)
    end

    it 'opens the donation page when donation name is clicked' do
      visit donations_path
      click_link donation.donor_name

      expect(page).to have_current_path(donation_path(donation))
    end

    it 'sorts donations by columns in ascending order when column header is clicked once' do
      # Implement the test logic for sorting by columns in ascending order
    end

    it 'sorts donations by columns in descending order when column header is clicked twice' do
      # Implement the test logic for sorting by columns in descending order
    end

    it 'opens the edit page of a donation when edit link is clicked' do
      # Implement the test logic for opening the edit page of a donation
    end

    it 'opens the donation page when donation name is clicked' do
      # Implement the test logic for opening the donation page when donation name is clicked
    end

    it 'opens the new donation creation page when new donation is clicked' do
      # Implement the test logic for opening the new donation creation page
    end
  end

  context 'Rainy Day' do

    it 'does not create a donation in the database when created with wrong attributes' do
      donationBad = Donation.create(
        donor_name: nil,
        amount: 1000,
        donation_date: '2021-04-01',
        campaign_id: 1
      )

      expect(donationBad).not_to be_persisted
    end

    it 'does not edit a donation in the database when edited with wrong attributes' do
      donation.update(amount: nil)

      expect(donation.reload.amount).not_to be_nil
    end

    it 'displays an error notice when searching for a donation that does not exist' do
      visit donations_path
      fill_in 'search', with: 'Test Donor'
      click_button 'Search'

      expect(page).to have_content('No donation found with the donor name')
    end
  end
end
